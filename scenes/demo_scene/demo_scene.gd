extends Node2D

@onready var game_manager = $GameManager
@onready var time_label: Label = $TestContainer/LeftContainer/TimeLabel
var game_time_manager: GameTimeManager

func _ready() -> void:
	_test_mail()
	game_time_manager = game_manager.game_time_manager
	game_time_manager.minute_changed.connect(_on_minute_changed)
	

func _test_mail() -> void:
	var att := MailAttachment.new()
	att.type = "item"
	att.item_id = "gold_coin"
	att.amount = 100
	MailManager.send_mail("系统", "新手奖励", "欢迎来到游戏！附送 100 金币。", [att])


func _on_minute_changed(hour: int, minute: int) -> void:
	time_label.text = game_time_manager.get_time_text()
