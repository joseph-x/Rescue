extends Resource
class_name MailData

@export var mail_id: String = ""        # 唯一 ID，如 "mail_1700000000_0"
@export var sender: String = ""         # 发件人名字
@export var title: String = ""          # 标题
@export var body: String = ""           # 正文
@export var send_time: int = 0          # 发送时间（Unix 时间戳）
@export var expire_time: int = 0        # 过期时间戳，0 = 永不过期
@export var is_read: bool = false       # 是否已读
@export var claimed: bool = false       # 附件是否已领取（幂等防重复）
@export var attachments: Array[MailAttachment] = []
