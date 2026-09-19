extends Node
class_name GameTimeManager


# ----------------------
# 游戏配置
# ----------------------
const EVENT_PROGRESS_STEP := 5

var current_time: float = 0
var start_time: float = 0
var end_time: float = INF
var running: bool = true

# 每秒游戏时间倍率
var time_scale:float = 1.0

# ==========================
# 时间数据
# ==========================
var day:int = 1
var hour:int = 0
var minute:int = 0
var second:int = 0

#region Signals
## 特殊事件开始
signal event_started(id:String)

## 特殊事件完成
signal event_completed(id:String)

## 特殊事件进度
signal event_progress(id:String, progress:float)

#endregion


#region TimeEventClass
# ----------------------
# 特殊时间事件
# ----------------------
class TimeEvent:
	var id:String
	
	var start_time:float
	var duration:float
	
	var started := false
	var finished := false
	
	# 上一次触发的百分比节点
	var last_progress_step:int = -1

	func _init(
		_id:String,
		_start:float,
		_duration:float
	):
		id = _id
		start_time = _start
		duration = _duration

#endregion

var events:Array[TimeEvent] = []

# ==========================
# 初始化时间范围
# ==========================
func setup(
	start_day:int,
	start_hour:int,
	start_minute:int,
	start_second:int,
	end_day:int=-1,
	end_hour:int=0,
	end_minute:int=0,
	end_second:int=0
):
	start_time = to_seconds(
		start_day,
		start_hour,
		start_minute,
		start_second
	)

	current_time=start_time

	if end_day>0:
		end_time = to_seconds(
			end_day,
			end_hour,
			end_minute,
			end_second
		)
	else:
		end_time=INF

	update_display()

# ==========================
# Process
# ==========================
func _process(delta: float) -> void:
	if not running:
		return
		
	current_time += (
		delta * time_scale
	)
	
	# 到达结束时间
	if current_time >= end_time:
		current_time = end_time
		update_display()
		running = false
		EventBus.time_finished.emit()
		return
	
	update_display()
	update_events()

func to_seconds(d:int, h:int, m:int, s:int) -> float:
	return (
		(d-1)*86400
		+h*3600
		+m*60
		+s
	)


func update_display() -> void:
	var value: int = int(current_time)
	day = floori(value / 86400.0) + 1
	
	var remain: int = value % 86400
	hour = floori(remain / 3600)
	
	remain %= 3600
	minute = floori(remain / 60)
	
	second = remain % 60
	
	EventBus.time_changed.emit(day, hour, minute, second)
	emit_total_progress()

# ==========================
# 时间控制
# ==========================
func pause() -> void:
	running = false


func resume() -> void:
	running = true


func set_speed(value:float) -> void:
	time_scale = max(value, 0)


func get_time() -> Dictionary:
	return {
		"day":day,
		"hour":hour,
		"minute":minute,
		"second":second
	}


# ==========================
# 特殊事件
# ==========================
func add_event(id:String, start:float, duration:float) -> void:
	events.append(
		TimeEvent.new(
			id,
			start,
			duration
		)
	)

func update_events() -> void:
	for e in events:
		if e.finished:
			continue
		
		if not e.started:
			if current_time >= e.start_time:
				e.started = true
				event_started.emit(e.id)
		
		if e.started:
			var progress: float =(current_time - e.start_time)/e.duration
			progress=clamp(progress, 0, 1)
			
			var percent := int(progress * 100)
			var step := int(
				float(percent) / EVENT_PROGRESS_STEP
			)
			
			if step > e.last_progress_step:
				e.last_progress_step=step
				event_progress.emit(e.id, step*EVENT_PROGRESS_STEP / 100.0)
			
			if progress>=1:
				e.finished=true
				event_completed.emit(e.id)
	

var last_progress:float=-1

func emit_total_progress():
	var p = get_total_progress()

	if abs(p - last_progress) > 0.0001:
		last_progress = p
		EventBus.time_progress.emit(p)

func get_total_progress()->float:
	if end_time<=start_time:
		return 0.0

	var progress := (current_time - start_time) / (end_time - start_time)
	
	return clamp(progress, 0.0, 1.0)


func get_time_text() -> String:
	# return "%02d:%02d:%02d" % [day, hour, minute]
	return "%02d:%02d" % [hour, minute]
