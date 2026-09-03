extends Node2D

@onready var loading_texture: Sprite2D = $ScenarioLoading
@onready var mat := loading_texture.material as ShaderMaterial

@onready var bar := $ColorRect/ProgressBarRect
@onready var bar_mat := bar.material as ShaderMaterial

var scenario_data: ScenarioData

# 假设这是你的加载进度（0.0 ~ 1.0）
var load_progress := 0.0
const scene_path = "res://scenes/scenario_gameplay_scene/scenario_gameplay_scene.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scenario_data = SceneData.scenario_data
	
	if scenario_data.loading_texture != null:
		loading_texture.texture = scenario_data.loading_texture

	ResourceLoader.load_threaded_request(scene_path)


func _process(_delta: float) -> void:
	# var progress_arr: Array
	# var status := ResourceLoader.load_threaded_get_status(scene_path, progress_arr)	
	# load_progress = progress_arr[0] if progress_arr.size() > 0 else 0.0
	
	# mat.set_shader_parameter("progress", load_progress)
	# bar_mat.set_shader_parameter("progress", load_progress)
	
	# if status == ResourceLoader.THREAD_LOAD_LOADED:
		# get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(scene_path))
	
	load_progress = load_progress + 0.05 * _delta
	
	if load_progress < 1.0:
		mat.set_shader_parameter("progress", load_progress)
		bar_mat.set_shader_parameter("progress", load_progress)
