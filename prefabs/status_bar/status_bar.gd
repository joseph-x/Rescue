extends Node2D

var _version_number: String = ""

@export var version_number: String : 
	set(value):
		_version_number = value
		if version_label:
			version_label.text = value
	get:
		return _version_number


@onready var version_label: Label = $Label

func _ready() -> void:
	version_label.text = _version_number
