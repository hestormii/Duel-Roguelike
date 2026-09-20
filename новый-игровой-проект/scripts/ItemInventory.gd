extends Node

var stock: Dictionary = {}
var money: int = 0


func add(item: ItemData, amount: int = 1) -> void:
	stock[item] = stock.get(item, 0) + amount

func remove(item: ItemData, amount: int = 1) -> void:
	if not stock.has(item):
		return
	stock[item] = max(0, stock[item] - amount)
	if stock[item] == 0:
		stock.erase(item)

func add_money(amount: int) -> void:
	money += amount

func spend_money(amount: int) -> bool:
	if amount > money:
		return false
	money -= amount
	return true
