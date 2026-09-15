extends Control

signal bullet_chosen(bullet: BulletData, amount: int)

@onready var slot_labels: Array[Label] = [
	$firstBullet/ColorRect/Label,
	$secondBullet/ColorRect1/Label2,
	$thirdBullet/ColorRect2/Label3,
]
@onready var amount_labels: Array[Label] = [
	$firstBullet/ColorRect/amount,
	$secondBullet/ColorRect1/amount2,
	$thirdBullet/ColorRect2/amount3,
]

var offered: Array[BulletData] = []
var offered_amounts: Array[int] = []


func populate() -> void:
	offered.clear()
	offered_amounts.clear()
	var pool := BulletTypes.all_bullets.duplicate()
	pool.shuffle()
	for i in min(slot_labels.size(), pool.size()):
		var bullet: BulletData = pool.get(i)
		var amount = randi_range(bullet.pickup_min, bullet.pickup_max)
		slot_labels[i].text = bullet.display_name
		amount_labels[i].text = "x%d" % amount
		offered.append(bullet)
		offered_amounts.append(amount)
		pool.remove_at(0)




func _on_color_rect_gui_input(event: InputEvent) -> void:
	_try_choose(event, 0)


func _on_color_rect_1_gui_input(event: InputEvent) -> void:
	_try_choose(event, 1)



func _on_color_rect_2_gui_input(event: InputEvent) -> void:
	_try_choose(event, 2)


func _try_choose(event: InputEvent, index: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		bullet_chosen.emit(offered.get(index), offered_amounts.get(index))
		queue_free()
