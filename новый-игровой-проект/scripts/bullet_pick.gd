extends Control

signal bullet_chosen(bullet: BulletData, amount: int)
@onready var animation_player: AnimationPlayer = $AnimationPlayer

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
@onready var bullet_sprites: Array[Sprite2D] = [
	$firstBullet/ColorRect/Sprite2D,
	$secondBullet/ColorRect1/Sprite2D2,
	$thirdBullet/ColorRect2/Sprite2D3
]

var offered: Array[BulletData] = []
var offered_amounts: Array[int] = []

func _ready() -> void:
	populate()
	animation()

func populate() -> void:
	offered.clear()
	offered_amounts.clear()
	var pool := BulletTypes.all_bullets.duplicate()
	pool.shuffle()
	for i in min(slot_labels.size(), pool.size()):
		var bullet: BulletData = pool.get(i)
		var amount = randi_range(bullet.pickup_min, bullet.pickup_max)
		var sprite = bullet.icon
		slot_labels[i].text = bullet.display_name
		amount_labels[i].text = "x%d" % amount
		bullet_sprites[i].texture = sprite
		offered.append(bullet)
		offered_amounts.append(amount)


func _on_color_rect_gui_input(event: InputEvent) -> void:
	_try_choose(event, 0)


func _on_color_rect_1_gui_input(event: InputEvent) -> void:
	_try_choose(event, 1)



func _on_color_rect_2_gui_input(event: InputEvent) -> void:
	_try_choose(event, 2)


func _try_choose(event: InputEvent, index: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		bullet_chosen.emit(offered.get(index), offered_amounts.get(index))
		if index == 0:
			animation_player.play("pick_first")
		if index == 1:
			animation_player.play("pick_second")
		if index == 2:
			animation_player.play("pick_third")


func animation():
	var tween_one := create_tween().set_loops()
	var tween_two := create_tween().set_loops()
	var tween_three := create_tween().set_loops()
	tween_one.tween_property(get_child(0), "rotation_degrees", 1.0, 1.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween_one.tween_property(get_child(0), "rotation_degrees", -1.0, 1.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween_two.tween_property(get_child(1), "rotation_degrees", 1.0, 1.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween_two.tween_property(get_child(1), "rotation_degrees", -1.0, 1.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween_three.tween_property(get_child(2), "rotation_degrees", 1.0, 1.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween_three.tween_property(get_child(2), "rotation_degrees", -1.0, 1.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "pick_first":
		queue_free()
	if anim_name == "pick_second":
		queue_free()
	if anim_name == "pick_third":
		queue_free()
