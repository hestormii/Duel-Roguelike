extends Node3D

const BULLET_PICK = preload("res://scenes/bullet_pick.tscn")
@onready var enemy_pos: Marker3D = $EnemyPos
@onready var player: Duelist = $PlayerTest
@onready var duel_manager: Node = $DuelManager
var current_bounty: BountyData
var current_reward: int = 0
@onready var shop: Node3D = $Shop
@onready var second: Node3D = $Second
@onready var player_pos: Marker3D = $PlayerPos

func _ready() -> void:
	duel_manager.duel_ended.connect(_on_duel_ended)
	shop.hide()
	second.hide()


func chose_the_bullet() -> void:
	var picker = BULLET_PICK.instantiate()
	add_child(picker)
	picker.populate()
	picker.bullet_chosen.connect(_on_bullet_chosen)

func start_duel_with(bounty: BountyData, reward: int) -> void:
	if bounty.enemy_scene == null:
		return
	current_bounty = bounty
	current_reward = reward
	var enemy = bounty.enemy_scene.instantiate()
	add_child(enemy)
	enemy.global_position = enemy_pos.global_position
	enemy.load_bullets(bounty.bullet, bounty.bullet_amount)  # now correctly before start_duel
	duel_manager.start_duel(player, enemy)
	player.change_DuelState_of_player()
	player.global_position = player_pos.global_position
	player.state_is_locked()



func _on_bullet_chosen(bullet: BulletData, amount: int) -> void:
	AmmoInventory.add(bullet, amount)
	player.change_DuelState_of_player()

func _on_bounty_chosen(bounty: BountyData, reward: int) -> void:
	if bounty.enemy_scene == null:
		return
	current_bounty = bounty
	current_reward = reward
	var enemy = bounty.enemy_scene.instantiate()
	add_child(enemy)
	enemy.global_position = enemy_pos.global_position
	duel_manager.start_duel(player, enemy)
	enemy.load_bullets(bounty.bullet, bounty.bullet_amount)

func _on_duel_ended(winner: Duelist) -> void:
	print("duel won by: ", winner.name)
	if winner == player and current_bounty:
		ItemInventory.add_money(current_reward)
	chose_the_bullet()
