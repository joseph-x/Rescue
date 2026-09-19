extends RefCounted
class_name GameEvent

var id:String
var start_time:float
var finished := false

var machine := EventStateMachine.new()


func update_time(current_time:float):
	machine.update(current_time)


func resolve():
	finished = true
