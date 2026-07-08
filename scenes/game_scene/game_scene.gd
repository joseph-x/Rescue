extends Node2D

@onready var menu_layer: CanvasLayer = $MenuLayer
@onready var crisis_bar: CrisisBar = $HUDLayer/ActionPanel/CrisisBar
@onready var time_bar: TimeBar = $HUDLayer/ActionPanel/TimeBar
@onready var game_time_manager: GameTimeManager = $GameManager/GameTimeManager


func _ready() -> void:
	menu_layer.hide()
	crisis_bar.set_level(EnumGlobal.CRISIS_LEVEL.MEDIUM)

	game_time_manager.minute_changed.connect(_on_minute_changed)
	game_time_manager.hour_changed.connect(_on_hour_changed)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			if menu_layer.visible == false:
				menu_layer.show()
			else:
				menu_layer.hide()

func _on_minute_changed(hour: int, minute: int) -> void:
	time_bar.set_time_text(game_time_manager.get_time_text())


func _on_hour_changed(hour: int) -> void:
	if hour == 1:
		crisis_bar.set_level(EnumGlobal.CRISIS_LEVEL.HIGH)
	if hour == 5:
		crisis_bar.set_level(EnumGlobal.CRISIS_LEVEL.CRITICAL)
	if hour == 8:
		crisis_bar.set_level(EnumGlobal.CRISIS_LEVEL.LOW)
