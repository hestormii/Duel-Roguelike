class_name BountyData extends Resource

@export var id: StringName
@export var display_name: String
@export var possible_names: Array[String] = []
@export var enemy_scene: PackedScene
@export var bullets: Array[BulletData] = []
@export var bullet_amounts: Array[int] = []
@export var reward_min: int = 0
@export var reward_max: int = 0

func roll_display_name() -> String:
	if possible_names.is_empty():
		return display_name
	return possible_names.pick_random()

func roll_reward() -> int:
	return randi_range(reward_min, reward_max)
