extends Node

enum Phase { PREPARATION, TARGETING, DUEL, RESOLUTION, AFTERMATH }

signal duel_ended(winner: Duelist)

@onready var secundant: Timer = $Secundant
@onready var enemy_reaction: Timer = $EnemyReaction
var phase: Phase = Phase.PREPARATION
var player: Duelist
var enemy: Duelist

var player_reacted: bool = false
var enemy_reacted: bool = false

const BODY_PART_ACCURACY := {"Head": 0.4, "Body": 0.75, "Hand": 0.55}
const BODY_PART_DAMAGE := {"Head": 5.0, "Body": 2.0, "Hand": 0.5}


func _process(delta: float) -> void:
	change_name_ofLabel()

func start_duel(p: Duelist, e: Duelist) -> void:
	player = p
	enemy = e
	if not player.died.is_connected(_on_duelist_died):
		player.died.connect(_on_duelist_died)
	enemy.died.connect(_on_duelist_died)
	enter_preparation()

func _on_duelist_died(who: Duelist) -> void:
	if phase == Phase.AFTERMATH:
		return  # already wrapping up, ignore any further deaths this duel
	var winner := enemy if who == player else player
	end_duel(winner)

func end_duel(winner: Duelist) -> void:
	phase = Phase.AFTERMATH
	duel_ended.emit(winner)

func enter_preparation() -> void:
	phase = Phase.PREPARATION
	player.reset_crystalls()
	enemy.reset_crystalls()
	print("--- PREPARATION --- action crystals: ", player.action_crystall)
	enemy.action_crystall = 0

func player_passed() -> void:
	if phase != Phase.PREPARATION:
		return
	player.action_crystall -= 1
	check_preparation_done()

func check_preparation_done() -> void:
	if player.action_crystall <= 0 and enemy.action_crystall <= 0:
		enter_targeting()

func enter_targeting() -> void:
	phase = Phase.TARGETING
	player.clear_queued_shots()
	enemy.clear_queued_shots()
	print("--- TARGETING --- choose your shots")
	_enemy_pick_targets()

func _enemy_pick_targets() -> void:
	var parts: Array[StringName] = ["Head", "Body", "Hand"]
	for i in enemy.base_shot_crystall:
		enemy.queue_shot(parts[randi() % parts.size()])

func player_queue_shot(body_part: StringName) -> void:
	if phase != Phase.TARGETING:
		return
	player.queue_shot(body_part)
	if player.shot_crystall <= 0:
		enter_duel()

func enter_duel() -> void:
	phase = Phase.DUEL
	player_reacted = false
	enemy_reacted = false
	print("--- The second raises his hand... ---")
	secundant.start(randf_range(2.0, 5.0))

func _on_secundant_timeout() -> void:
	print("--- FIRE! ---")
	enemy_reaction.start(randf_range(0.2, 0.8))

func _on_enemy_reaction_timeout() -> void:
	_register_reaction(enemy)
	print("enemy reacted")

func player_react() -> void:
	if phase != Phase.DUEL:
		return
	_register_reaction(player)
	print("player reacted")

func _register_reaction(who: Duelist) -> void:
	if who == player:
		if player_reacted:
			return
		player_reacted = true
	else:
		if enemy_reacted:
			return
		enemy_reacted = true
	if player_reacted and enemy_reacted:
		resolve_shots()

func resolve_shots() -> void:
	phase = Phase.RESOLUTION
	_fire_queued_shots(player, enemy)
	_fire_queued_shots(enemy, player)
	if phase != Phase.AFTERMATH:  # nobody died mid-resolution
		enter_resolution()

func _fire_queued_shots(shooter: Duelist, target: Duelist) -> void:
	for body_part in shooter.queued_shots:
		if phase == Phase.AFTERMATH or not is_instance_valid(target):
			return
		var bullet: BulletData = shooter.pop_bullet()
		if bullet == null:
			print(shooter.name, " dry-fires — out of bullets")
			continue
		var chance: float = BODY_PART_ACCURACY.get(body_part, 0.5)
		if randf() < chance:
			var final_damage: float = bullet.damage * BODY_PART_DAMAGE.get(body_part, 1.0)
			target.take_damage(final_damage)
			print(shooter.name, " hits the ", body_part, " for ", final_damage)
		else:
			print(shooter.name, " misses the ", body_part)

func enter_resolution() -> void:
	phase = Phase.RESOLUTION
	if not is_instance_valid(enemy):
		duel_ended.emit(player)
		return
	if not is_instance_valid(player):
		duel_ended.emit(enemy)
		return
	if is_out_of_ammo():
		var winner := player if player.current_health >= enemy.current_health else enemy
		end_duel(winner)
	else:
		enter_preparation()

func is_out_of_ammo() -> bool:
	return not player.has_bullets() and not enemy.has_bullets()

func change_name_ofLabel():
	if phase == Phase.PREPARATION:
		$Phase.text = "Current Phase is Preparation"
	elif phase == Phase.DUEL:
		$Phase.text = "Current Phase is Duel"
	elif phase == Phase.RESOLUTION:
		$Phase.text = "Current Phase is Resolution"
	elif phase == Phase.AFTERMATH:
		$Phase.text = "Current Phase is Rest"
		
