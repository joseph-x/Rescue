extends Node
class_name GameManager

@export var game_timeout: Vector3i = Vector3i.ZERO
var game_time_manager: GameTimeManager = GameTimeManager.new()
var data_manager: DataManager = DataManager.new()

func _ready() -> void:
	game_time_manager.real_seconds_per_game_minute = 1
	self.add_child(game_time_manager)
	
	game_time_manager.minute_changed.connect(_on_minute_changed)
	
	#SaveManager.save()
	#SaveManager.load()
	self.add_child(data_manager)

#region Events
func _on_minute_changed(_hour, _minute) -> void:
	# print(game_time_manager.get_time_text())
	_evaluate()

#endregion


#region Private Methods
## 游戏初始化
func _game_init() -> void:
	pass

## 游戏结束
func _game_end() -> void:
	pass

## 评估游戏状态
func _evaluate() -> void:
	if game_timeout.x == game_time_manager.day:
		if game_timeout.y == game_time_manager.hour:
			if game_timeout.z == game_time_manager.minute:
				print("Time Ended")
				game_time_manager.pause_time()

#endregion
