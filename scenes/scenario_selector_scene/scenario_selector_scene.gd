extends Node2D

const SCENARIO_ITEM := preload("res://scenes/scenario_selector_scene/components/scenario_item.tscn")

@export var scenario_data_list: Array = []

@onready var scroll: ScrollContainer = $ScrollContainer
@onready var row: HBoxContainer = $ScrollContainer/HBoxContainer

var buttons: Array[Button] = []
var current_index := 0

func _ready() -> void:
	# _test_scenairo_data()
	_init_buttons(scenario_data_list)
	select_level(0)

func _test_scenairo_data() -> void:
	print(scenario_data_list.size())
	for scenario in scenario_data_list:
		var d: ScenarioData = scenario as ScenarioData
		print(tr(d.display_name))
		print(tr(d.description))

func _init_buttons(data_list: Array) -> void:
	for scenario in data_list:
		var d: ScenarioData = scenario as ScenarioData
		var node := SCENARIO_ITEM.instantiate()
		row.add_child(node)

		var scenario_item: ScenarioItem = node as ScenarioItem
		buttons.append(scenario_item)
		
		scenario_item.current_state = ScenarioItem.ScenarioItemState.NORMAL
		scenario_item.set_with_data(d)
		
		scenario_item.focus_entered.connect(_on_button_focus_entered.bind(scenario_item))
		scenario_item.pressed.connect(_on_level_pressed.bind(scenario_item))
		scenario_item.mouse_entered.connect(_on_button_mouse_entered.bind(scenario_item))
		
		# 设置焦点
		for i in range(buttons.size()):
			if i > 0:
				buttons[i].focus_neighbor_left = buttons[i - 1].get_path()
			if i < buttons.size() - 1:
				buttons[i].focus_neighbor_right = buttons[i + 1].get_path()


func select_level(index: int) -> void:
	current_index = index
	
	for i in buttons:
		(i as ScenarioItem).set_normal_state()

	var item: ScenarioItem = buttons[index] as ScenarioItem
	item.grab_focus()
	item.set_selected_state()
	scroll.ensure_control_visible(item)       # 自动滚动到可见区域

func _on_button_focus_entered(btn: ScenarioItem) -> void:
	for i in buttons:
		(i as ScenarioItem).set_normal_state()
	btn.set_selected_state()
	current_index = buttons.find(btn)
	scroll.ensure_control_visible(btn)

func _on_button_mouse_entered(btn: ScenarioItem) -> void:
	for i in buttons:
		(i as ScenarioItem).set_normal_state()
	btn.grab_focus()
	btn.set_selected_state()
	current_index = buttons.find(btn)
	scroll.ensure_control_visible(btn)

func _on_level_pressed(btn: ScenarioItem) -> void:
	SceneData.scenario_data = btn.scenario_data
	get_tree().change_scene_to_file(Constants.SCENE_PATHS["ScenarioLoading"])
