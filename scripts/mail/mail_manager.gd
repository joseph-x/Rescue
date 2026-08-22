## 单机邮件系统核心管理器（作为 Autoload 单例挂载）
extends Node

signal mail_list_changed                        # 列表变化：红点 / 列表刷新
signal mail_added(mail: MailData)               # 新邮件到达：弹通知
signal attachment_claimed(mail_id: String)      # 附件已领取
signal mail_replied(original_id: String, reply_mail_id: String)

const SAVE_PATH := "user://mails.save"

var _mails: Array[MailData] = []

## 附件发放回调：由外部背包/资源系统注册。
## 签名：func(item_id: String, amount: int) -> bool，返回是否发放成功。
var item_grant_callback: Callable = Callable()

var reply_hook: Callable = Callable()

# ---------- 生命周期 ----------
func _ready() -> void:
	load_mails()


func save_mails() -> void:
	var data: Array[Dictionary] = []
	for mail: MailData in _mails:
		data.append(_to_dict(mail))
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("MailManager: 无法写入存档文件 %s" % SAVE_PATH)
		return
	# 最后一个参数 skip_escape_unicode=true，让中文以原文写入，方便调试
	file.store_string(JSON.stringify(data, "  ", false, true))
	file.close()


func load_mails() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_error("MailManager: 无法读取存档文件 %s" % SAVE_PATH)
		return
	var text := file.get_as_text()
	file.close()

	var parsed = JSON.parse_string(text)
	if typeof(parsed) != TYPE_ARRAY:
		push_warning("MailManager: 存档解析失败，邮件被清空")
		_mails.clear()
		return

	_mails.clear()
	for dict in parsed:
		if typeof(dict) == TYPE_DICTIONARY:
			_mails.append(_from_dict(dict))
	_clean_expired()


# ---------- 查询 ----------
func get_all_mails() -> Array[MailData]:
	return _mails


func get_mail(mail_id: String) -> MailData:
	return _find(mail_id)


func get_received() -> Array[MailData]:
	return _mails.filter(func(m: MailData) -> bool: return m.direction == 0)


func get_sent() -> Array[MailData]:
	return _mails.filter(func(m: MailData) -> bool: return m.direction == 1)


func get_unread_count() -> int:
	var count := 0
	for mail: MailData in _mails:
		if not mail.is_read:
			count += 1
	return count


func has_claimable_attachment() -> bool:
	for mail: MailData in _mails:
		if not mail.attachments.is_empty() and not mail.claimed:
			return true
	return false


func delete_mail(mail_id: String) -> bool:
	var index := _find_index(mail_id)
	if index == -1:
		return false
	_mails.remove_at(index)
	save_mails()
	mail_list_changed.emit()
	return true
	


# ---------- 发信 ----------
func send_mail(
	sender: String,
	title: String,
	body: String,
	attachments: Array[MailAttachment] = [],
	expire_seconds: int = 0,
) -> MailData:
	var mail := MailData.new()
	# ID 用 时间戳 + 当前数量 拼接，避免同秒多封冲突
	mail.mail_id = "mail_%d_%d" % [Time.get_unix_time_from_system(), _mails.size()]
	mail.sender = sender
	mail.title = title
	mail.body = body
	mail.send_time = Time.get_unix_time_from_system()
	if expire_seconds > 0:
		mail.expire_time = mail.send_time + expire_seconds
	mail.attachments = attachments

	_mails.append(mail)
	save_mails()
	mail_list_changed.emit()
	mail_added.emit(mail)
	return mail


## 回复一封收到的邮件：生成"玩家发送"的邮件进已发送箱
func reply_mail(original_id: String, reply_body: String, player_name: String = "玩家") -> String:
	var original := _find(original_id)
	if original == null:
		push_warning("MailManager: 回复目标邮件不存在 %s" % original_id)
		return ""

	var mail := MailData.new()
	mail.mail_id = "mail_%d_%d" % [Time.get_unix_time_from_system(), _mails.size()]
	mail.sender = player_name
	mail.title = "Re: %s" % original.title
	mail.body = reply_body
	mail.send_time = Time.get_unix_time_from_system()
	mail.direction = 1
	mail.reply_to = original_id

	original.replied = true

	_mails.append(mail)
	save_mails()
	mail_list_changed.emit()
	mail_added.emit(mail)

	if reply_hook.is_valid():
		reply_hook.call(original)
	mail_replied.emit(original_id, mail.mail_id)
	return mail.mail_id


# ---------- 状态操作 ----------
func mark_read(mail_id: String) -> void:
	var mail := _find(mail_id)
	if mail != null and not mail.is_read:
		mail.is_read = true
		save_mails()
		mail_list_changed.emit()


func claim_attachment(mail_id: String) -> bool:
	var mail := _find(mail_id)
	# 已领取 / 无附件 / 不存在 -> 拒绝
	if mail == null or mail.claimed or mail.attachments.is_empty():
		return false

	# 若已注册发放回调，逐件发放；任一失败则整体失败（不发、不标记）
	if item_grant_callback.is_valid():
		for att: MailAttachment in mail.attachments:
			if not item_grant_callback.call(att.item_id, att.amount):
				push_warning("MailManager: 附件发放失败，邮件 %s 未标记已领" % mail_id)
				return false

	mail.claimed = true
	save_mails()
	attachment_claimed.emit(mail_id)
	mail_list_changed.emit()
	return true


# ---------- 序列化 ----------
func _to_dict(mail: MailData) -> Dictionary:
	var attachments: Array[Dictionary] = []
	for att: MailAttachment in mail.attachments:
		attachments.append({
			"type": att.type,
			"item_id": att.item_id,
			"amount": att.amount,
		})
	return {
		"mail_id": mail.mail_id,
		"sender": mail.sender,
		"title": mail.title,
		"body": mail.body,
		"send_time": mail.send_time,
		"expire_time": mail.expire_time,
		"is_read": mail.is_read,
		"claimed": mail.claimed,
		"direction": mail.direction,
		"reply_to": mail.reply_to,
		"replied": mail.replied,
		"attachments": attachments,
	}


func _from_dict(dict: Dictionary) -> MailData:
	var mail := MailData.new()
	mail.mail_id = str(dict.get("mail_id", ""))
	mail.sender = str(dict.get("sender", ""))
	mail.title = str(dict.get("title", ""))
	mail.body = str(dict.get("body", ""))
	mail.send_time = int(dict.get("send_time", 0))
	mail.expire_time = int(dict.get("expire_time", 0))
	mail.is_read = bool(dict.get("is_read", false))
	mail.claimed = bool(dict.get("claimed", false))
	mail.direction = int(dict.get("direction", 0))
	mail.reply_to = str(dict.get("reply_to", ""))
	mail.replied = bool(dict.get("replied", false))
	
	for att_dict in dict.get("attachments", []):
		var att := MailAttachment.new()
		att.type = str(att_dict.get("type", ""))
		att.item_id = str(att_dict.get("item_id", ""))
		att.amount = int(att_dict.get("amount", 1))
		mail.attachments.append(att)

	return mail


# ---------- 内部工具 ----------
func _find(mail_id: String) -> MailData:
	for mail: MailData in _mails:
		if mail.mail_id == mail_id:
			return mail
	return null

func _find_index(mail_id: String) -> int:
	for i in _mails.size():
		if _mails[i].mail_id == mail_id:
			return i
	return -1

func _clean_expired() -> void:
	var now := Time.get_unix_time_from_system()
	_mails = _mails.filter(func(m: MailData) -> bool:
		return m.expire_time == 0 or m.expire_time > now
	)
	if _mails.size() > 0:
		save_mails()
