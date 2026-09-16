extends Control

signal bounty_chosen(bounty: BountyData)

@onready var name_labels: Array[Label] = [
	$PosterOne/ColorRect/Name,
	$PosterTwo/ColorRect1/Name2,
	$PosterThree/ColorRect2/Name3,
]
@onready var reward_labels: Array[Label] = [
	$PosterOne/ColorRect/reward,
	$PosterTwo/ColorRect1/reward1,
	$PosterThree/ColorRect2/reward2,
]

var offered: Array[BountyData] = []

func _ready() -> void:
	populate()
	animation()

func populate() -> void:
	offered.clear()
	var pool := EnemyTypes.all_enemies.duplicate()
	pool.shuffle()
	for i in min(name_labels.size(), pool.size()):
		var enemy: BountyData = pool.get(i)
		var reward_amount = randi_range(enemy.reward_min, enemy.reward_max)
		name_labels[i].text = enemy.display_name
		reward_labels[i].text = "$%d" % reward_amount
		offered.append(pool.get(i))

func _on_color_rect_gui_input(event: InputEvent) -> void:
	_try_choose(event, 0)

func _on_color_rect_1_gui_input(event: InputEvent) -> void:
	_try_choose(event, 1)

func _on_color_rect_2_gui_input(event: InputEvent) -> void:
	_try_choose(event, 2)

func _try_choose(event: InputEvent, index: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		bounty_chosen.emit(offered[index])
		queue_free()

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
