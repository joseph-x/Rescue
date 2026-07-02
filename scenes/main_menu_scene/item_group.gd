extends VBoxContainer

@onready var start_mission_button: MainMenuItem = $MainMenuItem
@onready var case_file_button: MainMenuItem = $MainMenuItem2
@onready var hospital_button: MainMenuItem = $MainMenuItem3
@onready var vehicles_buuton: MainMenuItem = $MainMenuItem4
@onready var crew_button: MainMenuItem = $MainMenuItem5
@onready var achievement_button: MainMenuItem = $MainMenuItem6
@onready var settings_button: MainMenuItem = $MainMenuItem7

var button_group: Array = []

func _ready() -> void:
	start_mission_button.item_clicked.connect(_item_clicked)
	case_file_button.item_clicked.connect(_item_clicked)
	hospital_button.item_clicked.connect(_item_clicked)
	vehicles_buuton.item_clicked.connect(_item_clicked)
	crew_button.item_clicked.connect(_item_clicked)
	achievement_button.item_clicked.connect(_item_clicked)
	settings_button.item_clicked.connect(_item_clicked)
	
	button_group.append(start_mission_button)
	button_group.append(case_file_button)
	button_group.append(hospital_button)
	button_group.append(vehicles_buuton)
	button_group.append(crew_button)
	button_group.append(achievement_button)
	button_group.append(settings_button)
	

func _item_clicked(item: MainMenuItem) -> void:
	for i: MainMenuItem in button_group:
		if i != item:
			i.set_state(MainMenuItem.Item_State.Normal)
