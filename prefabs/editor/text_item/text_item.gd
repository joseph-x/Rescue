extends Node

@export var label_name: String
@export var text: String

@onready var label: Label = $Label
@onready var text_input: LineEdit = $LineEdit

func _ready() -> void:
	label.text = label_name
	text_input.text = text
