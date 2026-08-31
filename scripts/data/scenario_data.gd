extends Resource
class_name ScenarioData

@export var id: String
@export var display_name: String
@export var description: String
@export var difficulty: int
@export var achievements: Dictionary
@export var thumbnail: Texture2D
@export var stories: Array
@export var diseases: Array

func get_display_name() -> String:
	return tr(display_name)

func get_display_description() -> String:
	return tr(description)
