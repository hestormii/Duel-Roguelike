extends Node

const SAVE_PATH := "user://savegame.tres"

func save_game() -> void:
	var data := SaveData.new()
	data.money = ItemInventory.money
	data.ammo_stock = AmmoInventory.stock.duplicate()
	data.item_stock = ItemInventory.stock.duplicate()
	data.unlocked_bullets = BulletTypes.all_bullets.duplicate()
	data.held_posters = PosterInventory.held_posters.duplicate(true)
	var error := ResourceSaver.save(data, SAVE_PATH)
	if error != OK:
		push_error("Save failed: " + str(error))

func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false
	var data: SaveData = load(SAVE_PATH)
	if data == null:
		return false
	ItemInventory.money = data.money
	AmmoInventory.stock = data.ammo_stock.duplicate()
	ItemInventory.stock = data.item_stock.duplicate()
	BulletTypes.all_bullets = data.unlocked_bullets.duplicate()
	PosterInventory.held_posters = data.held_posters.duplicate(true)
	return true
