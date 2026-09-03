extends Button
class_name ScenarioItem

@export var scenario_data: ScenarioData
@export var current_state: ScenarioItemState = ScenarioItemState.NORMAL
@export var is_locked: bool = true

@onready var loacation_label: Label = $LocationLabel
@onready var thumbnail_rect: TextureRect = $Thumbnail

enum ScenarioItemState {
	NORMAL,
	SELECTED
}


func _ready() -> void:
	set_normal_state()


func set_with_data(d: ScenarioData) -> void:
	scenario_data = d
	loacation_label.text = tr(d.display_name)
	thumbnail_rect.texture = d.thumbnail


func set_selected_state() -> void:
	self.modulate.a = 1.0


func set_normal_state() -> void:
	self.modulate.a = 0.6
