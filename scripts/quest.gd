extends Resource
class_name Quest

@export var patient: Patient
@export var disease: Disease
@export var description: String
@export var current_state: QUEST_STATE

enum QUEST_STATE {
	Locked,
	Available,
	InProgress,
	Completed,
	Finished,
	Failed,
	Expired
}
