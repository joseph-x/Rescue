extends GameEvent
class_name MedicalEvent

enum MedicalEventState
{
	STABLE,
	DETERIORATING,
	CRITICAL,
	DEAD,
	RESOLVED
}

var state:MedicalEventState = MedicalEventState.STABLE
var deterioration_time := 180.0
var critical_time := 360.0
var death_time := 600.0

signal state_changed(new_state)

func _init() -> void:
	id = "heart_attack"


func setup() -> void:
	var stable = EventState.new()
	stable.id = "stable"
	stable.duration=180
	stable.next_state="danger"

	var danger=EventState.new()
	danger.id="danger"
	danger.duration=180
	danger.next_state="critical"

	var critical=EventState.new()
	critical.id="critical"
	critical.duration=240
	critical.next_state="dead"
	
	machine.add_state(stable)
	machine.add_state(danger)
	machine.add_state(critical)

	machine.start("stable", start_time)


func update_time(current_time):
	var elapsed = current_time - start_time
	if elapsed >= death_time:
		change_state(MedicalEventState.DEAD)
	elif elapsed >= critical_time:
		change_state(MedicalEventState.CRITICAL)
	elif elapsed >= deterioration_time:
		change_state(MedicalEventState.DETERIORATING)


func change_state(new_state):
	if state == new_state:
		return

	state = new_state
	state_changed.emit(state)
