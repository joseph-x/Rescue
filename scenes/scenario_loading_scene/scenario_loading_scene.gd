extends Node2D

var scenario_data: ScenarioData

@onready var loading_texture: Sprite2D = $ScenarioLoading
@onready var mat := loading_texture.material as ShaderMaterial

@onready var bar := $ColorRect/ProgressBarRect
@onready var bar_mat := bar.material as ShaderMaterial

# 假设这是你的加载进度（0.0 ~ 1.0）
var load_progress := 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scenario_data = SceneData.scenario_data
	
	if scenario_data.loading_texture != null:
		loading_texture.texture = scenario_data.loading_texture
		
	print(scenario_data)


func _process(_delta: float) -> void:
	load_progress = load_progress + 0.05 * _delta
	
	if load_progress < 1.0:
		mat.set_shader_parameter("progress", load_progress)
		bar_mat.set_shader_parameter("progress", load_progress)
