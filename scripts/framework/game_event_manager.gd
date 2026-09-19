extends Node
class_name EventManager

@onready var time_manager: GameTimeManager = %TimeManager

@export var medical_event_definitions: Array[MedicalEventDefinition] = []

var active_events:Array[GameEvent] = []

func _ready():
	EventBus.time_progress.connect(_on_time_progress)
	EventBus.time_changed.connect(_on_time_changed)
	
func _on_time_progress(progress:float) -> void:
	var p: int = progress * 10000 # 00.01%
	
	if p == 20:
		spawn_medical_event()


func spawn_medical_event():
	if medical_event_definitions.is_empty():
		return null

	var definition: MedicalEventDefinition = medical_event_definitions.pick_random()
	var event := MedicalEvent.new(definition)

	event.event_condition_changed.connect(_on_event_condition_changed)
	event.event_resolved.connect(_on_event_resolved)
	event.event_cancelled.connect(_on_event_cancelled)

	event.start(time_manager.current_time)
	
	active_events.append(event)

	print("发生医疗事件: ", definition.display_name, " / ", event.event_id)

	return event


func _on_event_condition_changed(old_condition: MedicalEvent.Condition, new_condition: MedicalEvent.Condition) -> void:
	print("病情变化: ", old_condition, " -> ", new_condition)


func _on_event_resolved(event: GameEvent) -> void:
	active_events.erase(event)
	print("事件结束: ", event.event_id)


func _on_event_cancelled(event: GameEvent) -> void:
	active_events.erase(event)
	print("事件取消: ", event.event_id)


func _on_time_changed(day: int, hour: int, minute: int, second: int):
	var time: float = time_manager.to_seconds(day, hour, minute, second)
	
	for event in active_events:
		event.update_time(time)
