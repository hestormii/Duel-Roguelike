extends Control

signal bullet_chosen(bullet: BulletData, amount: int)

const CARD_SCENE := preload("res://scenes/bullet_card.tscn")
@onready var grid: GridContainer = $GridContainer
const CARD_COUNT := 3


func populate() -> void:
	for child in grid.get_children():
		child.queue_free()
	var pool := BulletTypes.all_bullets.duplicate()
	pool.shuffle()
	for i in min(CARD_COUNT, pool.size()):
		var bullet: BulletData = pool[i]
		var amount := randi_range(bullet.pickup_min, bullet.pickup_max)
		var card = CARD_SCENE.instantiate()
		grid.add_child(card)
		card.setup(bullet.display_name, "x%d" % amount, bullet.icon, {"bullet": bullet, "amount": amount})
		card.chosen.connect(_on_card_chosen)

func _on_card_chosen(payload: Dictionary) -> void:
	bullet_chosen.emit(payload["bullet"], payload["amount"])
	queue_free()
	print("smth")
