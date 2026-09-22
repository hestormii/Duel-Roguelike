class_name BountyData extends Resource

@export var id: StringName
@export var display_name: String
@export var reward: int
@export var enemy_scene: PackedScene
@export var bullets: Array[BulletData] = []
@export var bullet_amounts: Array[int] = []
@export var reward_min: int = 0
@export var reward_max: int = 0
@export var type_enemy: String
