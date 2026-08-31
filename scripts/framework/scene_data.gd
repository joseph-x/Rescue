## Autoload类型 SceneData，用于场景间传递数据/对象
extends Node

@export var scenario_data: ScenarioData

func reset_all() -> void:
	scenario_data = null
