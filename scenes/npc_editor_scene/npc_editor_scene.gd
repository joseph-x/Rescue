extends Control

@onready var quit_button = $VBoxContainer/PanelContainer/HBoxContainer/QuitButton
@onready var load_button = $VBoxContainer/PanelContainer/HBoxContainer/LoadButton
@onready var save_button = $VBoxContainer/PanelContainer/HBoxContainer/SaveButton
@onready var new_npc_button = $VBoxContainer/PanelContainer/HBoxContainer/NewNPCButton

@onready var character_selector = $VBoxContainer/HBoxContainer/CharacterSelector

var character_manager: EditorCharacterManager = EditorCharacterManager.new()
var item_list_data: Array = []

func _ready() -> void:
	
	quit_button.button_up.connect(_on_quit_button_up)
	load_button.button_up.connect(_on_load_button_up)
	save_button.button_up.connect(_on_save_button_up)
	new_npc_button.button_up.connect(_on_new_npc_button_up)
	
	character_manager.load()
	
	_load_selector(character_manager.patients)

#region Events
func _on_quit_button_up() -> void:
	get_tree().change_scene_to_file(Constants.SCENE_PATHS["MainMenu"])


func _on_load_button_up() -> void:
	character_manager.load()


func _on_save_button_up() -> void:
	character_manager.save()


func _on_new_npc_button_up() -> void:
	character_manager.new_character(EnumGlobal.CHARACTER_TYPE.PATIENT)

#endregion


#region Private Methods
func _load_selector(items: Array) -> void:
	for i in items:
		var index = character_selector.add_item(i["name"], null, true)
		character_selector.set_item_metadata(index, i)
		character_selector.item_selected.connect(_on_character_selector_item_selected)

func _on_character_selector_item_selected(index: int) -> void:
	var item = character_selector.get_item_metadata(index)
	print(item["uid"])
#endregion
