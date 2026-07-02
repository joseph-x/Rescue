extends Node2D

@onready var menu_layer: CanvasLayer = $MenuLayer
@onready var crisis_bar: CrisisBar = $HUDLayer/ActionPanel/CrisisBar

func _ready() -> void:
	menu_layer.hide()
	crisis_bar.set_level(EnumGlobal.CRISIS_LEVEL.MEDIUM)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			if menu_layer.visible == false:
				menu_layer.show()
			else:
				menu_layer.hide()
