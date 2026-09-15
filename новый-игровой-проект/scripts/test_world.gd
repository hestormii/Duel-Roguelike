extends Node3D

const BULLET_PICK = preload("res://scenes/bullet_pick.tscn")
const WANTED_POSTERS = preload("res://scenes/wanted_posters.tscn")
@onready var enemy_pos: Marker3D = $EnemyPos
@onready var player: Duelist = $PlayerTest
@onready var duel_manager: Node = $DuelManager

func _ready() -> void:
	duel_manager.duel_ended.connect(_on_duel_ended)
	chose_next_target()


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
	duel_manager.start_duel(player, enemy)

func _on_duel_ended(winner: Duelist) -> void:
	print("duel won by: ", winner.name)
	chose_the_bullet()
