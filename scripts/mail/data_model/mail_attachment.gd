extends Resource
class_name MailAttachment

@export var type: String = "item"   # "item" / "currency" / "exp"
@export var item_id: String = ""    # 物品/资源 ID
@export var amount: int = 1         # 数量
