extends Node
class_name EventManager

@onready var time_manager: GameTimeManager = %TimeManager

var active_events:Array[GameEvent] = []

func _ready():
	EventBus.time_progress.connect(_on_time_progress)
	EventBus.time_changed.connect(_on_time_changed)
	
func _on_time_progress(progress:float) -> void:
	var p: int = progress * 10000 # 00.01%
	
	if p == 20:
		spawn_medical_event()


func spawn_medical_event():
	var event = MedicalEvent.new()
	event.start_time = time_manager.current_time
	event.state_changed.connect(_on_event_state_changed)
	
	active_events.append(event)
	
	print("发生医疗事件:", event.id)

func _on_time_changed(day: int, hour: int, minute: int, second: int):
	var time: float = time_manager.to_seconds(day, hour, minute, second)
	
	for event in active_events:
		event.update_time(time)


func _on_event_state_changed(state):
	print("病情变化:", state)
