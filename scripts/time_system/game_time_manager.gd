extends Node
class_name GameTimeManager

# 游戏时间状态
var current_tick: int = 0
var current_minute: int = 0
var current_hour: int = 8
var current_day: int = 1
var current_shift: int = 1

# 当前游戏速度
var current_speed: int = EnumGlobal.GAME_SPEED.NORMAL

# 计时器
var tick_timer: Timer = Timer.new()

# 时间事件注册表 (时间间隔 -> 回调列表)
var tick_events: Dictionary = {}
var minute_events: Dictionary = {}
var hour_events: Dictionary = {}
var shift_events: Dictionary = {}
var day_events: Dictionary = {}

# 信号定义
signal time_tick(tick: int, minute: int, hour: int, day: int)
signal minute_passed(minute: int, hour: int, day: int)
signal hour_passed(hour: int, day: int)
signal shift_changed(shift: int, day: int)
signal day_changed(day: int)
signal speed_changed(speed: int)


func _ready() -> void:
	pass
