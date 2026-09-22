extends Node

@export var stats: BaseEnemyData

func _ready() -> void:
	generate_enemy()


func generate_enemy():
	stats.display_name = stats.possible_names.pick_random()
	var self_name = stats.display_name
	stats.reward = randi_range(stats.reward_min, stats.reward_max)
	var reward = stats.reward
	print(self_name)
	print(reward)
