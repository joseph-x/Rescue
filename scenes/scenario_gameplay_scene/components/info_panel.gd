extends Control
class_name GameplayInfoPanel

@onready var city_label: Label = %CityNameLabel
@onready var weather_label: Label = %WeatherLabel
@onready var time_label: Label = %TimeLabel
@onready var time_button: Button = $HBoxContainer/TimeButton
@onready var time_progress_bar: ProgressBar = %ProgressBar

@export var time_manager: GameTimeManager

var previous_time_scale: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time_button.pressed.connect(_on_time_scale_button_pressed)
	EventBus.time_changed.connect(_on_time_changed)
	EventBus.time_progress.connect(_on_time_progress)
	

func _show_time(time_data: String) -> void:
	time_label.text = time_data


func _on_time_scale_button_pressed() -> void:
	if time_manager.running == true:
		previous_time_scale = time_manager.time_scale
		time_manager.set_speed(0.0)
		time_manager.running = false
	else:
		time_manager.set_speed(previous_time_scale)
		previous_time_scale = 0.0
		time_manager.running = true


func _on_time_changed(day:int, hour: int, minute: int, second: int) -> void:
	var current_time: String = "%02d日 %02d:%02d:%02d" % [
		day,
		hour,
		minute,
		second
	]
	_show_time(current_time)
	

func _on_time_progress(progress: float) -> void:
	var value: int = progress * 100
	time_progress_bar.value = value
