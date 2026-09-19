class_name MedicalEventDefinition
extends Resource

@export var event_id: StringName
@export var display_name: String

@export_group("Patient")
@export var min_age: int = 18
@export var max_age: int = 80

@export_group("Diagnosis")
@export var hidden_diagnosis: StringName

@export_group("Information")
@export var initial_information: Dictionary = {}

@export_group("Condition")
@export var deterioration_after: float = 180.0
@export var critical_after: float = 360.0
@export var cardiac_arrest_after: float = 600.0
