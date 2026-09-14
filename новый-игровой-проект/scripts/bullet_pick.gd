extends Control

signal bullet_chosen(bullet: BulletData)

@onready var slot_labels: Array[Label] = [
	$firstBullet/ColorRect/Label,
	$secondBullet/ColorRect1/Label2,
	$thirdBullet/ColorRect2/Label3,
]

var offered: Array[BulletData] = []

func _ready() -> void:
	populate()

func populate() -> void:
	offered.clear()
	var pool := BulletTypes.all_bullets.duplicate()
	pool.shuffle()
	for i in min(slot_labels.size(), pool.size()):
		slot_labels[i].text = pool.get(i).display_name
		offered.append(pool.get(i))
		pool.remove_at(0)
		print(slot_labels[i].text)
		print(offered.get(i))

func _on_color_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print(offered.get(0))
		bullet_chosen.emit(offered.get(0))
		self.queue_free()


func _on_color_rect_1_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print(offered.get(1))
		bullet_chosen.emit(offered.get(1))
		self.queue_free()



func _on_color_rect_2_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print(offered.get(2))
		bullet_chosen.emit(offered.get(2))
		self.queue_free()


func _on_bullet_chosen(bullet: BulletData) -> void:
	AmmoInventory.add(bullet)
	print(AmmoInventory.stock)
