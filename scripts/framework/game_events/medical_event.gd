extends GameEvent
class_name MedicalEvent

@export var definition: MedicalEventDefinition

#region signals
signal event_condition_changed(old_condition: Condition, new_condition: Condition)

signal information_updated
signal treatment_applied(treatment_id: StringName)
#endregion

enum Condition {
	STABLE,
	DETERIORATING,
	CRITICAL,
	CARDIAC_ARREST,
	DECEASED				# Dead
}

enum Outcome {
	UNKNOWN,
	STABILIZED,
	RECOVERED,
	DECEASED
}

# ============================================================
# Patient
# ============================================================
var patient_age: int = 0

# 真实症状
var symptoms: Dictionary = {}

# 玩家已经获得的信息
var known_information: Dictionary = {}

# 玩家不能直接看到
var hidden_diagnosis: StringName = &""


# ============================================================
# Medical condition
# ============================================================
var condition: Condition = Condition.STABLE
var outcome: Outcome = Outcome.UNKNOWN


# ============================================================
# Treatment
# ============================================================
var treatments_applied: Array[StringName] = []

var cpr_started: bool = false
var oxygen_applied: bool = false


# ============================================================
# Initialization
# ============================================================

func _init(event_definition: MedicalEventDefinition) -> void:
	super(&"", &"medical")

	definition = event_definition
	event_id = definition.event_id



# ============================================================
# Start
# ============================================================

func start(current_time: float) -> void:
	super.start(current_time)

	condition = Condition.STABLE
	outcome = Outcome.UNKNOWN

	patient_age = randi_range(
		definition.min_age,
		definition.max_age
	)
	
	known_information = definition.initial_information.duplicate(true)


# ============================================================
# Time
# ============================================================

func update_time(current_time: float) -> void:
	if not is_active():
		return

	var elapsed := get_elapsed_time(current_time)
	_update_condition(elapsed)


func _update_condition(elapsed: float) -> void:
	if condition == Condition.DECEASED:
		return
	
	if elapsed >= definition.cardiac_arrest_after:
		set_condition(Condition.CARDIAC_ARREST)
		return

	if elapsed >= definition.critical_after:
		set_condition(Condition.CRITICAL)
		return

	if elapsed >= definition.deterioration_after:
		set_condition(Condition.DETERIORATING)
		return

	if condition != Condition.STABLE:
		set_condition(Condition.STABLE)


# ============================================================
# Condition
# ============================================================

func set_condition(new_condition: Condition) -> void:
	if condition == new_condition:
		return
	
	var old_condition := condition
	condition = new_condition
	
	event_condition_changed.emit(old_condition, new_condition)
	_on_condition_changed(old_condition, new_condition)


func _on_condition_changed(old_condition: Condition, new_condition: Condition) -> void:
	match new_condition:
		Condition.CARDIAC_ARREST:
			_on_cardiac_arrest()
		Condition.DECEASED:
			_on_deceased()
		_:
			pass


func _on_cardiac_arrest() -> void:
	# 这里只表示病情进入心脏骤停。
	# 不应该立即把事件判定为失败。
	pass


func _on_deceased() -> void:
	outcome = Outcome.DECEASED


# ============================================================
# Information
# ============================================================

func add_information(key: StringName, value: Variant) -> void:
	if known_information.get(key) == value:
		return

	known_information[key] = value
	information_updated.emit()


func knows_information(key: StringName) -> bool:
	return known_information.has(key)


func get_information(key: StringName) -> Variant:
	return known_information.get(key)


# ============================================================
# Treatment
# ============================================================

func apply_treatment(treatment_id: StringName) -> void:
	if treatments_applied.has(treatment_id):
		return

	treatments_applied.append(treatment_id)
	
	match treatment_id:
		&"cpr":
			cpr_started = true
		&"oxygen":
			oxygen_applied = true

	treatment_applied.emit(treatment_id)


# ============================================================
# Medical queries
# ============================================================

func is_critical() -> bool:
	return condition == Condition.CRITICAL


func is_cardiac_arrest() -> bool:
	return condition == Condition.CARDIAC_ARREST


func is_deceased() -> bool:
	return condition == Condition.DECEASED


# ============================================================
# Complete
# ============================================================

func stabilize(current_time: float) -> void:
	condition = Condition.STABLE
	outcome = Outcome.STABILIZED

	resolve(current_time)


func recover(current_time: float) -> void:
	outcome = Outcome.RECOVERED

	resolve(current_time)


func die(current_time: float) -> void:
	set_condition(Condition.DECEASED)
	outcome = Outcome.DECEASED

	resolve(current_time)
