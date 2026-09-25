extends Node

@export var base_enemies: Array[BountyData] = []
@export var elite_enemies: Array[BountyData] = []

func get_random_mix() -> Array[BountyData]:
	var result: Array[BountyData] = []
	var pool := base_enemies.duplicate()
	pool.shuffle()
	result.append(pool[0])
	result.append(pool[1])
	if randf() < 0.3 and not elite_enemies.is_empty():
		result.append(elite_enemies.pick_random())
	else:
		result.append(pool[2])
	return result
