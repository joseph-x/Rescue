extends Resource
class_name CharacterBase

@export var uid: String
@export var name: String:
	get:
		return name
	set(value):
		name = value
		var time = Time.get_ticks_msec()
		var rand_part = randi_range(100000, 999999)
		uid = str(time) + str(rand_part)
		
@export var age: int
@export var gender: GENDER


enum GENDER{
	Female,
	Male,
}
