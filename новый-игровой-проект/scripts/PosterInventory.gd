extends Node

var held_posters: Array[Dictionary] = []

func add_poster(bounty: BountyData, reward: int) -> void:
	held_posters.append({"bounty": bounty, "reward": reward})

func remove_poster(index: int) -> void:
	held_posters.remove_at(index)
