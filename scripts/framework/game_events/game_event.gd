extends RefCounted
class_name GameEvent

#region Events
signal event_phase_changed(old_phase: Phase, new_phase: Phase)
signal event_lifecycle_changed(old_lifecycle: Lifecycle, new_lifecycle: Lifecycle)

signal event_resolved(event: GameEvent)
signal event_failed(event: GameEvent)
signal event_cancelled(event: GameEvent)

#endregion

enum Lifecycle {
	INACTIVE,
	ACTIVE,
	RESOLVED,
	FAILED,
	CANCELLED
}

enum Phase {
	NEW,
	RECEIVED,
	PROCESSING,
	DISPATCHED,
	RESPONDING,
	ON_SCENE,
	COMPLETED
}


var event_id: StringName
var event_type: StringName
var lifecycle: Lifecycle = Lifecycle.INACTIVE
var phase: Phase = Phase.NEW


# 事件在 TimeManager 中的开始时间
var start_time: float = 0.0
var end_time: float = -1.0



func _init(id: StringName = &"", type: StringName = &"") -> void:
	event_id = id
	event_type = type


# --------------------------------------------------
# 生命周期
# --------------------------------------------------
func start(current_time: float) -> void:
	start_time = current_time
	end_time = -1.0
	lifecycle = Lifecycle.ACTIVE
	phase = Phase.NEW


func resolve(current_time: float) -> void:
	if lifecycle != Lifecycle.ACTIVE:
		return

	var old_lifecycle := lifecycle
	lifecycle = Lifecycle.RESOLVED
	
	end_time = current_time
	
	event_lifecycle_changed.emit(old_lifecycle, lifecycle)
	event_resolved.emit(self)


func fail(current_time: float) -> void:
	if lifecycle != Lifecycle.ACTIVE:
		return

	var old_lifecycle := lifecycle

	lifecycle = Lifecycle.FAILED
	end_time = current_time
	
	event_lifecycle_changed.emit(old_lifecycle, lifecycle)
	event_failed.emit(self)

func cancel(current_time: float) -> void:
	if lifecycle != Lifecycle.ACTIVE:
		return

	var old_lifecycle := lifecycle
	lifecycle = Lifecycle.CANCELLED
	end_time = current_time
	
	event_lifecycle_changed.emit(old_lifecycle, lifecycle)
	event_cancelled.emit(self)

# ============================================================
# Phase
# ============================================================
func set_phase(new_phase: Phase) -> void:
	if phase == new_phase:
		return
	
	var old_phase := phase
	phase = new_phase

	event_phase_changed.emit(old_phase, new_phase)

func is_inactive() -> bool:
	return lifecycle == Lifecycle.INACTIVE


func is_active() -> bool:
	return lifecycle == Lifecycle.ACTIVE


func is_resolved() -> bool:
	return lifecycle == Lifecycle.RESOLVED


func is_cancelled() -> bool:
	return lifecycle == Lifecycle.CANCELLED

# ============================================================
# Time
# ============================================================
func get_elapsed_time(current_time: float) -> float:
	return current_time - start_time


func update_time(current_time: float) -> void:
	if not is_active():
		return
