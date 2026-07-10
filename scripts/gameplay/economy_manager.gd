extends Node
class_name EconomyManager

@export var money: int = 0
@export var credit: int = 0


func init(money: int, credit: int) -> void:
	self.money = money
	self.credit = credit


#region Money
func add_money(amount: int) -> void:
	pass


func spend_money(amount: int) -> void:
	pass

#endregion


#region Credit
func add_credit(amount: int) -> void:
	EventBus.credit_changed.emit(amount)


func spend_credit(amount: int) -> void:
	EventBus.credit_changed.emit(-amount)

#endregion
