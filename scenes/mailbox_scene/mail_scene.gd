extends Control

@onready var mail_list: ItemList = $HBoxContainer/MailList
@onready var title_label: Label = $HBoxContainer/DetailPanel/VBoxContainer/TitleLabel
@onready var sender_label: Label = $HBoxContainer/DetailPanel/VBoxContainer/SenderLabel
@onready var body_label: Label = $HBoxContainer/DetailPanel/VBoxContainer/BodyLabel

@onready var claim_button: Button = $HBoxContainer/DetailPanel/VBoxContainer/ClaimButton
@onready var reply_button: Button = $HBoxContainer/DetailPanel/VBoxContainer/ReplyButton
@onready var delete_button: Button = $HBoxContainer/DetailPanel/VBoxContainer/DeleteButton

@onready var detail_panel: PanelContainer = $HBoxContainer/DetailPanel
@onready var badge: Label = $HBoxContainer/MailList/Badge


var _selected_id: String = ""
var _reply_target_id: String = ""


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MailManager.mail_list_changed.connect(_refresh_list)
	MailManager.mail_list_changed.connect(_update_badge)
	MailManager.attachment_claimed.connect(_on_attachment_claimed)
	
	mail_list.item_selected.connect(_on_item_selected)
	mail_list.item_activated.connect(_on_item_selected)
	
	claim_button.pressed.connect(_on_claim_pressed)
	reply_button.pressed.connect(_on_reply_pressed)
	delete_button.pressed.connect(_on_delete_pressed)
	
	_refresh_list()
	_update_badge()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _refresh_list() -> void:
	mail_list.clear()
	
	for mail: MailData in MailManager.get_all_mails():
		var prefix := "[未读] " if not mail.is_read else ""
		var att_suffix := "  [附件]" if (not mail.claimed and not mail.attachments.is_empty()) else ""
		mail_list.add_item(prefix + mail.title + att_suffix)
		mail_list.set_item_metadata(mail_list.item_count - 1, mail.mail_id)
		
		visible = mail_list.item_count > 0



func _update_badge() -> void:
	var count := MailManager.get_unread_count()
	badge.visible = count > 0
	badge.text = str(count)

func _on_attachment_claimed(mail_id: String) -> void:
	if mail_id == _selected_id:
		claim_button.visible = false
		claim_button.disabled = true


func _on_item_selected(index: int) -> void:
	var mail_id: String = mail_list.get_item_metadata(index)
	_selected_id = mail_id
	MailManager.mark_read(mail_id)
	_show_detail(mail_id)


func _on_delete_pressed() -> void:
	if _selected_id != "":
		MailManager.delete_mail(_selected_id)


func _on_claim_pressed() -> void:
	if _selected_id != "":
		MailManager.claim_attachment(_selected_id)


func _on_reply_pressed() -> void:
	_reply_target_id = _selected_id
	
	if _reply_target_id == "":
		return
	var new_id := MailManager.reply_mail(_reply_target_id, "reply_input_text")
	if new_id != "":
		print("reply sucuessful")


func _show_detail(mail_id: String) -> void:
	var mail := MailManager.get_mail(mail_id)
	if mail == null:
		return
	title_label.text = mail.title
	sender_label.text = "发件人：%s" % mail.sender
	body_label.text = mail.body
	var has_att := not mail.attachments.is_empty() and not mail.claimed
	claim_button.visible = has_att
	claim_button.disabled = not has_att
	detail_panel.visible = true
