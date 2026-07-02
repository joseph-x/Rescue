extends Container
class_name MainMenuItem

@onready var background: TextureRect = $Background
@onready var primary_label: Label = $Background/PrimaryLabel
@onready var secondnary_label: Label = $Background/SecondnaryLabel
@onready var icon: TextureRect = $Background/Icon

@export var is_selected: bool = false
@export var item_type: Item_Type

signal item_clicked

const icon_size: Vector2 = Vector2(32, 32)


var current_state: Item_State = Item_State.Normal
var atlas_texture: AtlasTexture = AtlasTexture.new()


var icon_set: Dictionary = {
	"start_mission_normal": Vector2(0, 0),
	"start_mission_selected": Vector2(0, 32),
	"case_files_normal": Vector2(32, 0),
	"case_files_selected": Vector2(32, 32),
	"hospital_normal": Vector2(64, 0),
	"hospital_selected": Vector2(64, 32),
	"vehicles_normal": Vector2(96, 0),
	"vehicles_selected": Vector2(96, 32),
	"crew_normal": Vector2(128, 0),
	"crew_selected": Vector2(128, 32),
	"achievement_normal": Vector2(160, 0),
	"achievement_selected": Vector2(160, 32),
	"settings_normal": Vector2(192, 0),
	"settings_selected": Vector2(192, 32),
	"exit_normal": Vector2(224, 0),
	"exit_selected": Vector2(224, 32)
}

var bg_set: Dictionary = {
	"normal": load("res://assets/game_ui/main_menu_scene/main_menu_item_bg.png"),
	"hovered": load("res://assets/game_ui/main_menu_scene/main_menu_item_bg_hovered.png"),
	"selected": load("res://assets/game_ui/main_menu_scene/main_menu_item_bg_selected.png")
}

enum Item_State {
	Normal,
	Hovered,
	Selected
}

enum Item_Type {
	START_MISSION,
	CASE_FILES,
	HOSPITAL_HQ,
	VEHICLES,
	CREW_TEAM,
	ACHIEVEMENTS,
	SETTINGS,
	EXIT
}

func _ready() -> void:
	atlas_texture.atlas = preload("res://assets/game_ui/main_menu_scene/main_icons.png")
	
	inital_content(item_type)
		
	if is_selected == true:
		set_state(Item_State.Selected)
	else:
		set_state(Item_State.Normal)
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	gui_input.connect(_user_input)

func _on_mouse_entered() -> void:
	if current_state != Item_State.Selected:
		set_state(Item_State.Hovered)
	
func _on_mouse_exited() -> void:
	if is_selected != true:
		set_state(Item_State.Normal)

func _user_input(event: InputEvent) -> void:
	if event is InputEventMouse:
		if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			set_state(Item_State.Selected)
			item_clicked.emit(self)

func set_state(state: Item_State) -> void:
	match state:
		Item_State.Normal:
			is_selected = false
			current_state = Item_State.Normal
			self.modulate.a = 0.4
			# secondnary_label.add_theme_color_override("font_color", Color("#FFFFFF"))
			background.texture = bg_set["normal"]
		Item_State.Hovered:
			current_state = Item_State.Hovered
			self.modulate.a = 0.8
			# secondnary_label.add_theme_color_override("font_color", Color("#FF00FF"))
			background.texture = bg_set["hovered"]
		Item_State.Selected:
			is_selected = true
			current_state = Item_State.Selected
			self.modulate.a = 1.0
			# secondnary_label.add_theme_color_override("font_color", Color("#FF0000"))
			background.texture = bg_set["selected"]
			

func inital_content(type: Item_Type) -> void:
	match type:
		Item_Type.START_MISSION:
			_set_item_details("开始任务", "START MISSION", "start_mission_normal")
		Item_Type.CASE_FILES:
			_set_item_details("任务档案", "CASE FILES", "case_files_normal")
		Item_Type.HOSPITAL_HQ:
			_set_item_details("医院管理", "HOSPITAL HQ", "hospital_normal")
		Item_Type.VEHICLES:
			_set_item_details("车辆装备", "VEHICLES & GEAR", "vehicles_normal")
		Item_Type.CREW_TEAM:
			_set_item_details("急救队伍", "EMS CREW", "crew_normal")
		Item_Type.ACHIEVEMENTS:
			_set_item_details("成就排行", "ACHIEVEMENTS", "achievement_normal")
		Item_Type.SETTINGS:
			_set_item_details("系统设置", "SETTINGS", "settings_normal")
		Item_Type.EXIT:
			_set_item_details("退出游戏", "EXIT", "exit_normal")


func _set_item_details(primary_text: String, secondnary_text: String, altas_name: String) -> void:
	primary_label.text = primary_text
	secondnary_label.text = secondnary_text
	atlas_texture.region =  Rect2(icon_set[altas_name], icon_size)
	icon.texture = atlas_texture
