extends Node2D

func _ready() -> void:
	SaveManager.save()
	SaveManager.load()
	
	var data_manager: DataManager = DataManager.new()
	self.add_child(data_manager)
	
