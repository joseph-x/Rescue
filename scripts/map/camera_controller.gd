extends Camera2D


@export var move_speed := 800.0
@export var zoom_speed := 0.15
@export var min_zoom := 0.5
@export var max_zoom := 3.0

var dragging = false

func _process(delta):
	var input_dir = Vector2(
		Input.get_axis("ui_left","ui_right"),
		Input.get_axis("ui_up","ui_down")
	)

	if input_dir:
		position += input_dir * move_speed * delta / zoom.x


func _input(event):
	# 鼠标拖动
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed

		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			change_zoom(zoom_speed)

		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			change_zoom(-zoom_speed)

	if event is InputEventMouseMotion and dragging:
		position -= event.relative / zoom



func change_zoom(value):
	zoom += Vector2.ONE * value
	zoom.x = clamp(
		zoom.x,
		min_zoom,
		max_zoom
	)

	zoom.y = zoom.x
