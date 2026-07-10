extends Node

@export var player_name: String = "Steve Gu"

func to_save_data() -> Dictionary:
	var data := {
		"name": player_name
	}
	
	return data
	

func from_save_data(data: Dictionary) -> void:
	var new_data := data.duplicate(true)
	player_name = new_data.get("name")
