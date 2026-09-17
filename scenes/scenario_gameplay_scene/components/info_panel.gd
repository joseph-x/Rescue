extends Control
class_name GameplayInfoPanel

@onready var city_label: Label = %CityNameLabel
@onready var weather_label: Label = %WeatherLabel
@onready var time_label: Label = %TimeLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func show_time(time_data: String) -> void:
	time_label.text = time_data
