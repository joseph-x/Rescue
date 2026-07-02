extends Node2D

@onready var demo_scene_button = $ActionUILayer/SideNav/ItemGroup/DemoButton
@onready var npc_editor_scene_button = $ActionUILayer/SideNav/ItemGroup/NPCEditorButton
@onready var system_settings_button = $ActionUILayer/SideNav/ItemGroup/MainMenuItem7
@onready var exit_game_button = $ActionUILayer/SideNav/ItemGroup/MainMenuItem8

@onready var play_button = $ActionUILayer/MainContainer/PlayButton

func _ready() -> void:
	demo_scene_button.button_up.connect(_on_demo_scene_button)
	npc_editor_scene_button.button_up.connect(_on_npc_editor_scene_button)
	
	play_button.button_up.connect(_on_play_game)
	
	exit_game_button.item_clicked.connect(_on_exit_game)
	system_settings_button.item_clicked.connect(_on_settings)


#region Button Events
func _on_demo_scene_button() -> void:
	get_tree().change_scene_to_file(Constants.SCENE_PATHS["Demo"])


func _on_npc_editor_scene_button() -> void:
	get_tree().change_scene_to_file(Constants.SCENE_PATHS["NPCEditor"])
	

func _on_play_game() -> void:
	#TODO: new game inital
	get_tree().change_scene_to_file(Constants.SCENE_PATHS["GamePlay"])

func _on_exit_game(_item: MainMenuItem) -> void:
	get_tree().quit()
	

func _on_settings(_item: MainMenuItem) -> void:
	get_tree().change_scene_to_file(Constants.SCENE_PATHS["Settings"])


#endregion


#region Private Methods


#endregion
