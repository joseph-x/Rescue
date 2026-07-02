extends Node2D

@export var version_number: String : 
	set(value):
		version_number = value
		version_label.text = version_number
	get:
		return version_number


@onready var version_label: Label = $Label
