extends Node2D

@onready var game_manager = $GameManager

func _ready() -> void:
	_test_mail()
	

func _test_mail() -> void:
	var att := MailAttachment.new()
	att.type = "item"
	att.item_id = "gold_coin"
	att.amount = 100
	MailManager.send_mail("系统", "新手奖励", "欢迎来到游戏！附送 100 金币。", [att])
