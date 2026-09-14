extends Control

signal enemy_chosen(enemy: BountyData)

@onready var opponent_names: Array[Label] = [
	$PosterOne/ColorRect/Name,
	$PosterTwo/ColorRect2/Name2,
	$PosterThree/ColorRect3/Name3
]
@onready var reward_price: Array[Label] = [
	$PosterOne/ColorRect/reward,
	$PosterTwo/ColorRect2/reward,
	$PosterThree/ColorRect3/reward
]

var offered: Array[BountyData] = []

func populate() -> void:
	offered.clear()
	var pool := BountyRegistry.all_enemies.duplicate()
	pool.shuffle()
	for i in min(opponent_names.size(), pool.size()):
		offered.append(pool[i])
		opponent_names[i].text = pool[i].display_name
		reward_price[i].text = "$%d" % pool[i].price


func _on_color_rect_gui_input(event: InputEvent, index: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		enemy_chosen.emit(offered[index])
