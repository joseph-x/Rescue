extends Node
class_name GameTimeManager


signal minute_changed(hour: int, minute: int)
signal hour_changed(hour: int)
signal day_changed(day: int)

@export var real_seconds_per_game_minute := 0.05
@export var start_hour := 0
@export var start_minute := 0

var day := 0
var hour := 0
var minute := 0

var _accumulator := 0.0
var _paused := false
var time_scale := 1.0


# 游戏速度倍率
enum GAME_SPEED {
	PAUSED = 0,
	NORMAL = 1,
	FAST = 2,
	FASTEST = 4
}


func _ready():
	hour = start_hour
	minute = start_minute

func _process(delta: float) -> void:
	if _paused:
		return

	_accumulator += delta * time_scale

	while _accumulator >= real_seconds_per_game_minute:
		_accumulator -= real_seconds_per_game_minute
		_add_minute()

func _add_minute() -> void:
	minute += 1

	if minute >= 60:
		minute = 0
		hour += 1
		hour_changed.emit(hour)

	if hour >= 24:
		hour = 0
		day += 1
		day_changed.emit(day)

	minute_changed.emit(hour, minute)

func pause_time():
	_paused = true

func resume_time():
	_paused = false

func set_time_scale(value: float):
	time_scale = max(value, 0.0)

func get_time_text() -> String:
	return "%02d:%02d:%02d" % [day, hour, minute]
