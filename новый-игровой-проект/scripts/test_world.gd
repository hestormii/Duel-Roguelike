extends Node3D

const BULLET_PICK = preload("res://scenes/bullet_pick.tscn")
const WANTED_POSTERS = preload("res://scenes/wanted_posters.tscn")
@onready var enemy_pos: Marker3D = $EnemyPos

func _ready() -> void:
	chose_next_target()

func _on_enemy_test_died(who: Duelist) -> void:
	chose_the_bullet()

func _on_player_test_died(who: Duelist) -> void:
	pass

func chose_the_bullet() -> void:
	var picker = BULLET_PICK.instantiate()
	add_child(picker)
	picker.populate()
	picker.bullet_chosen.connect(_on_bullet_chosen)

func chose_next_target() -> void:
	var poster = WANTED_POSTERS.instantiate()
	add_child(poster)
	poster.populate()
	poster.bounty_chosen.connect(_on_bounty_chosen)

func _on_bullet_chosen(bullet: BulletData, amount: int) -> void:
	AmmoInventory.add(bullet, amount)
	chose_next_target()

func _on_bounty_chosen(bounty: BountyData) -> void:
	if bounty.enemy_scene == null:
		return
	var enemy = bounty.enemy_scene.instantiate()
	add_child(enemy)
	enemy.global_position = enemy_pos.global_position
	enemy.died.connect(_on_enemy_test_died)
