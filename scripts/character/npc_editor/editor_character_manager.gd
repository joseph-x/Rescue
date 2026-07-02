extends Node
class_name EditorCharacterManager

@export var patients: Array = []
@export var staff: Array = []
@export var npcs: Array = []

const DATA_PATH = "res://game_data/npc.json"
const NAME_PATIENT = "patients"
const NAME_STAFF = "staff"

var name_manager: NameManager = NameManager.new()
var data_root: Dictionary = {}


#region Public Methods
func new_character(character_type: EnumGlobal.CHARACTER_TYPE) -> void:
	match character_type:
		EnumGlobal.CHARACTER_TYPE.PATIENT:
			var p: Patient = Patient.new()
			var gender: int = randi_range(0, 1)
			p.name = name_manager.get_random_name(gender)
			patients.append(p)
			
		EnumGlobal.CHARACTER_TYPE.STAFF:
			var s: Staff = Staff.new()
			var gender: int = randi_range(0, 1)
			s.name = name_manager.get_random_name(gender)
			staff.append(s)
	
func save() -> void:	
	var p_dict_array: Array = []
	for p in patients:
		var p_dict: Dictionary = {}
		p_dict["uid"] = p.uid
		p_dict["name"] = p.name
		p_dict["gender"] = p.gender
		p_dict["age"] = p.age
		p_dict_array.append(p_dict)
	
	var s_dict_array: Array =[]
	for s in staff:
		var s_dict: Dictionary = {}
		s_dict["uid"] = s.uid
		s_dict["name"] = s.name
		s_dict["gender"] = s.gender
		s_dict["age"] = s.age
		s_dict_array.append(s_dict)
	
	data_root[NAME_PATIENT] = p_dict_array
	data_root[NAME_STAFF] = s_dict_array

	var file = FileAccess.open(DATA_PATH,FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data_root,"  "))
		file.close()
	
func load() -> void:
	_load_from_json()
	name_manager.load()

#endregion

#region Private Methods
func _load_from_json() -> void:
	if not FileAccess.file_exists(DATA_PATH):
		print("文件不存在: ", DATA_PATH)
	
	var file = FileAccess.open(DATA_PATH, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	
	var json_text = JSON.parse_string(content)
	
	if typeof(json_text) == TYPE_DICTIONARY:
		var dict: Dictionary = json_text
		_process_json(dict)


func _process_json(root: Dictionary) -> void:
	patients = root[NAME_PATIENT]
	print(patients)

#endregion
