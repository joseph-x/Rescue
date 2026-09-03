extends Node2D

var scenario_data: ScenarioData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scenario_data = SceneData.scenario_data


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
