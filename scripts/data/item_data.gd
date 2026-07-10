extends BaseData
class_name ItemData

@export_group("Inventory")
@export_range(1,9999) var max_stack: int = 99

@export_group("Economy")
@export var buy_price: int = 0
@export var sell_price: int = 0
