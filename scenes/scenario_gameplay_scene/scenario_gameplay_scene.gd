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
	
	info_panel.time_manager = time_manager
	
	_setup_timer()

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _setup_timer() -> void:
	time_manager.setup(
		1, 6, 0, 0,
		3, 22, 0,0
	)
	time_manager.set_speed(600.0)

	
	var earthquake_time = time_manager.to_seconds(1, 12, 0, 0)
	time_manager.add_event(
		"earthquake",
		earthquake_time,
		20*60
	)
	time_manager.event_progress.connect(
		func(id,p):
			print(id,p*100,"%")
	)
