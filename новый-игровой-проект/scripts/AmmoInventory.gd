extends Node

var stock: Dictionary = {}

func add(bullet: BulletData, amount: int = 1) -> void:
	stock[bullet] = stock.get(bullet, 0) + amount

func remove(bullet: BulletData, amount: int = 1) -> void:
	if not stock.has(bullet):
		return
	stock[bullet] = max(0, stock[bullet] - amount)
	if stock[bullet] == 0:
		stock.erase(bullet)

func draw_random() -> BulletData:
	var total := 0
	for count in stock.values():
		total += count
	if total == 0:
		return null
	var roll := randi() % total
	var running := 0
	for bullet in stock.keys():
		running += stock[bullet]
		if roll < running:
			remove(bullet, 1)
			return bullet
	return null
