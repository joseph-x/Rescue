extends Node

# const SAVE_PATH = "user://saved_game.tres"
const SAVE_PATH = "user://save_game.json"
const NAME_INVENTORY = "inventory"
const NAME_PLAYER_INFO = "player_info"
const NAME_CONFIG = "system_config"

@export var is_autosave: bool = false
@export var save_data: Dictionary = {}

func save() -> void:
	EventBus.before_save.emit()
	
	save_data = {
		NAME_INVENTORY: InventoryManager.to_save_data(),
		NAME_PLAYER_INFO: PlayerManager.to_save_data(),
		NAME_CONFIG: ConfigManager.to_save_data()
	}
	
	print(save_data)
	
	# 写文件
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("无法创建存档文件")
		return
	
	file.store_string(JSON.stringify(save_data,"\t"))
	file.close()
	
	EventBus.game_saved.emit()


func load() -> void:
	
	if not FileAccess.file_exists(SAVE_PATH):
		print("没有找到存档文件")
		return
		
	EventBus.before_load.emit()
	
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	var json_text := file.get_as_text()
	file.close()
	
	var result = JSON.parse_string(json_text)
	
	if result == null:
		push_error("存档解析失败")
		return
	
	InventoryManager.from_save_data(result.get(NAME_INVENTORY, {}))
	PlayerManager.from_save_data(result.get(NAME_PLAYER_INFO, {}))
	ConfigManager.from_save_data(result.get(NAME_CONFIG, {}))
	
	EventBus.game_loaded.emit()


func autosave() -> void:
	pass
