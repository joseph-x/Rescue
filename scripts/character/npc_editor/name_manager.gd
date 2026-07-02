extends Node
class_name NameManager

@export var names: Array = []

const DATA_PATH = "res://game_data/npc.json"
const DATA_NAME = "NPCs"

const NAME_BASE_PATH = "res://game_data/family_name_base.json"
const NAME_BASE_NAME = "names"
const NAME_FAMILY_NAME = "family_name"
const NAME_FEMALE_NAME_D = "female_name_d"
const NAME_FEMALE_NAME_E1 = "female_name_e1"
const NAME_FEMALE_NAME_E2 = "female_name_e2"
const NAME_MALE_NAME_D = "male_name_d"
const NAME_MALE_NAME_E1 = "male_name_e1"
const NAME_MALE_NAME_E2 = "male_name_e2"

var npcs: Dictionary = {}

var name_json_data: Dictionary

var name_family: Array
var name_female_d: Array
var name_female_e1: Array
var name_female_e2: Array
var name_male_d: Array
var name_male_e1: Array
var name_male_e2: Array


#region Public Methods
func test_flight() -> void:
	print(get_random_name(0))

func load() -> void:	
	if not FileAccess.file_exists(NAME_BASE_PATH):
		print("文件不存在: ", NAME_BASE_PATH)
	
	var file = FileAccess.open(NAME_BASE_PATH, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	
	var json_text = JSON.parse_string(content)
	
	if typeof(json_text) == TYPE_DICTIONARY:
		var dict: Dictionary = json_text
		name_json_data = dict[NAME_BASE_NAME]
		
		name_family = name_json_data[NAME_FAMILY_NAME]
		
		name_female_d = name_json_data[NAME_FEMALE_NAME_D]
		name_female_e1 = name_json_data[NAME_FEMALE_NAME_E1]
		name_female_e2 = name_json_data[NAME_FEMALE_NAME_E2]
		name_male_d = name_json_data[NAME_MALE_NAME_D]
		name_male_e1 = name_json_data[NAME_MALE_NAME_E1]
		name_male_e2 = name_json_data[NAME_MALE_NAME_E2]
		

func save() -> void:
	pass

func get_random_name(gender: int) -> String:
	var name: String
	
	var family_name_index: int = randi_range(0, name_family.size() - 1)
	var family_name = name_family[family_name_index]
	
	# var gender: int = randi_range(0,1)		# 0-female；1-male
	var last_name_length: int = randi_range(0,1)	# 0-2bit; 1-3bit
	
	var last_name1: String
	var last_name2: String
	
	match gender:
		0:
			if last_name_length == 0:
				var last_name_index: int = randi_range(0, name_female_d.size() - 1)
				last_name1 = name_female_d[last_name_index]
			else:
				var last_name_index1: int = randi_range(0, name_female_e1.size() - 1)
				var last_name_index2: int = randi_range(0, name_female_e2.size() - 1)
				last_name1 = name_female_e1[last_name_index1]
				last_name2 = name_female_e2[last_name_index2]
		1:
			if last_name_length == 0:
				var last_name_index: int = randi_range(0, name_male_d.size() - 1)
				last_name1 = name_male_d[last_name_index]
			else:
				var last_name_index1: int = randi_range(0, name_male_e1.size() - 1)
				var last_name_index2: int = randi_range(0, name_male_e2.size() - 1)
				last_name1 = name_male_e1[last_name_index1]
				last_name2 = name_male_e2[last_name_index2]
	
	name = family_name + last_name1 + last_name2
	return name

#endregion
