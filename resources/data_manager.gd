extends Node
class_name DataManager

const BUILDING_PATH := "res://resources/building"

var buildings: Dictionary = {}

func _ready() -> void:
	buildings = _load_directory(BUILDING_PATH, HospitalBuilding)
	
	

func _load_directory(path: String, expected_type: Variant) -> Dictionary:
	var result: Dictionary = {}
	var directory := DirAccess.open(path)
	
	if directory == null:
		push_error("无法打开数据目录：%s" % path)
		return result
	
	directory.list_dir_begin()
	
	var file_name := directory.get_next()
	while file_name != "":
		if directory.current_is_dir():
			file_name = directory.get_next()
			continue
		
		if not file_name.ends_with(".tres") and not file_name.ends_with(".res"):
			file_name = directory.get_next()
			continue
		
		var resource_path := path.path_join(file_name)
		var resource := ResourceLoader.load(resource_path)
		
		if resource == null:
			push_error("Resource 加载失败 %s" % resource_path)
			file_name = directory.get_next()
			continue
		
		if not is_instance_of(resource, expected_type):
			push_error("Resource 类型不匹配： %s，实际类型：%s" % [resource_path, resource.get_class()])
			file_name = directory.get_next()
			continue
		
		if resource.id == &"":
			push_error("数据ID为空： %s" % resource_path)
			file_name = directory.get_next()
			continue
		
		if result.has(resource.id):
			push_error("发现重复数据ID： %s， 文件：%s" % [resource.id, resource_path])
			file_name = directory.get_next()
			continue
			
		result[resource.id] = resource
		file_name = directory.get_next()
		
	directory.list_dir_end()
		
	return result
