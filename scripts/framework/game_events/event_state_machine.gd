extends RefCounted
class_name EventStateMachine

signal state_changed(old_state,new_state)

var current_state: String
var states: Dictionary = {}
var state_start_time: float = 0


func add_state(state:EventState):
	states[state.id]=state


func start(first_state:String, current_time:float):
	current_state = first_state
	state_start_time = current_time


func update(current_time:float):
	if not states.has(current_state):
		return
	var state:EventState = states[current_state]

	var elapsed = (current_time - state_start_time)
	
	if elapsed >= state.duration:
		if state.next_state != "":
			change_state(state.next_state, current_time)


func change_state(new_state:String, current_time:float):
	var old=current_state

	current_state=new_state
	state_start_time=current_time

	state_changed.emit(old, new_state)
