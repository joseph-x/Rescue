extends VBoxContainer
class_name TimeBar

@onready var label: Label = $Label
@onready var time_label: Label = $TimeLabel

func set_time_text(text: String) -> void:
	time_label.text = text 
