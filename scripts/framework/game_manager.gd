extends Node
class_name GameManager

var game_time_manager: GameTimeManager = GameTimeManager.new()
var data_manager: DataManager = DataManager.new()

func _ready() -> void:
	game_time_manager.real_seconds_per_game_minute = 1
	self.add_child(game_time_manager)
	
	game_time_manager.minute_changed.connect(_on_minute_changed)
	
	#SaveManager.save()
	#SaveManager.load()
	self.add_child(data_manager)

#region Events
func _on_minute_changed(hour, minute) -> void:
	print(game_time_manager.get_time_text())

#endregion


#region Private Methods
func _game_init() -> void:
	pass
#endregion
