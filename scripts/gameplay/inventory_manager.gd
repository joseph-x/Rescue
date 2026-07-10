extends Node

var items: Dictionary = {}

func to_save_data() -> Dictionary:
	return items.duplicate(true)

func from_save_data(data: Dictionary) -> void:
	items = data.duplicate(true)
	EventBus.inventory_changed.emit()
