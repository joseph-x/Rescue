extends BaseRuntime
class_name BuildingRuntime

@export var grid_position: Vector2i

func to_save_data() -> Dictionary:
	var data: Dictionary = {
		"instance_id": instance_id,
		"data_id": data_id,
		"grid_position": {
			"x": grid_position.x,
			"y": grid_position.y
		}
	}
	
	return data

static func from_save_data(save_data: Dictionary) -> BuildingRuntime:
	var runtime: BuildingRuntime = BuildingRuntime.new()
	
	runtime.instance_id = save_data.get("instance_id", "")
	runtime.data_id = save_data.get("data_id", "")
	
	var position_data: Dictionary = save_data.get("grid_position", {})
	runtime.grid_position = Vector2i(int(position_data.get("x",0)), int(position_data.get("y",0)))
	
	return runtime
