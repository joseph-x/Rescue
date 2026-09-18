extends Resource
class_name ScenarioData

@export var id: String
@export var display_name: String
@export var description: String
@export var difficulty: int
@export var achievements: Dictionary
@export var thumbnail: Texture2D
@export var loading_texture: Texture2D
@export var stories: Array
@export var diseases: Array
@export_file("*.json") var map_path: String


func get_display_name() -> String:
	return tr(display_name)

func get_display_description() -> String:
	return tr(description)

#region map
const NAME_SEGMENTS = "segments"
const NAME_BUILDINGS = "buildings"

var segments_data: Array
var buildings_data: Array

func load_map_data() -> void:
	if not FileAccess.file_exists(map_path):
		print("没有找到存档文件")
		return
	
	var file := FileAccess.open(map_path, FileAccess.READ)
	
	if file == null:
		push_error("读取存档失败")
		return
	
	var json_text := file.get_as_text()
	file.close()
	
	var result = JSON.parse_string(json_text)
	
	if result == null:
		push_error("存档解析失败")
		return
	
	segments_data = result.get(NAME_SEGMENTS,[])
	buildings_data = result.get(NAME_BUILDINGS, [])

#endregion
