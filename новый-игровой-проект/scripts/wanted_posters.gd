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

func populate() -> void:
	offered.clear()
	var pool := EnemyTypes.all_enemies.duplicate()
	pool.shuffle()
	for i in min(name_labels.size(), pool.size()):
		name_labels[i].text = pool.get(i).display_name
		reward_labels[i].text = "$%d" % pool[i].reward
		offered.append(pool.get(i))
		pool.remove_at(0)


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
