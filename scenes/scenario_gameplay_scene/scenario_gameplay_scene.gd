extends Node2D

@onready var time_manager: GameTimeManager = %TimeManager
@onready var city_manager: CityManager = %CityManager
@onready var info_panel: GameplayInfoPanel = $UILayer/InfoPanel


var scenario_data: ScenarioData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scenario_data = SceneData.scenario_data
	scenario_data.load_map_data()
	
	city_manager.set_segments(scenario_data.segments_data)
	city_manager.set_buildings(scenario_data.buildings_data)
	
	time_manager.minute_changed.connect(_on_minute_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_minute_changed(hour: int, minute: int) -> void:
	info_panel.show_time(time_manager.get_time_text())
