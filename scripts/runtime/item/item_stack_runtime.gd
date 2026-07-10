extends BaseRuntime
class_name ItemStackRuntime

@export var amount: int = 0

func _init(id: String = &"", amount: int = 0) -> void:
	self.instance_id = id
	self.amount = amount


func is_empty() -> bool:
	return instance_id == &"" or amount <= 0


func clear() -> void:
	instance_id = &""
	amount = 0

func duplicate_stack() -> ItemStackRuntime:
	return ItemStackRuntime.new(instance_id, amount)

func to_save_data() -> Dictionary:
	return {
		"instance_id": String(instance_id),
		"data_id": String(data_id),
		"amount": amount
	}

static func from_save_data(data: Dictionary) -> ItemStackRuntime:
	return ItemStackRuntime.new(
		String(data.get("instance_id","")),
		int(data.get("amount", 0))
	)
