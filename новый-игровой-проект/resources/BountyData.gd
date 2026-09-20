class_name BountyData extends Resource

@export var id: StringName
@export var display_name: String
@export var reward: int
@export var enemy_scene: PackedScene
@export var bullet_amount: int
@export var bullet: BulletData
@export var reward_min: int = 0
@export var reward_max: int = 0
@export var type_enemy: String
