extends Node2D

var scenario_data: ScenarioData

@onready var test_label: Label = $TestLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scenario_data = SceneData.scenario_data
	print(scenario_data)
	test_label.text = tr(scenario_data.description)
