extends Node

@export var label_name: String
@export var options: Dictionary
@export var current_option: int


@onready var label: Label = $Label
@onready var option_button: OptionButton = $OptionButton

func _ready() -> void:
	label.text = label_name
	option_button.item_selected.connect(_option_selected)
	_init_option_button()


func _init_option_button() -> void:	
	pass


func _option_selected(index: int) -> void:
	current_option = index
