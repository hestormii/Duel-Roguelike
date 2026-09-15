extends Node

enum Phase { PREPARATION, DUEL, RESOLUTION, AFTERMATH }

signal duel_ended(winner: Duelist)

@onready var secundant: Timer = $Secundant

var phase: Phase = Phase.PREPARATION
var player: Duelist
var enemy: Duelist

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
		enter_duel()

func enter_duel() -> void:
	phase = Phase.DUEL
	var time = randi_range(2, 5)
	print("--- The second raises his hand... ---")
	secundant.start(time)
	enemy.shot_crystall = 0

func _on_secundant_timeout() -> void:
	$Phase.text = "SHOT!!!"
	print("--- FIRE! --- shots available: ", player.shot_crystall)

func on_shot_fired(who: Duelist) -> void:
	if phase != Phase.DUEL:
		return
	who.shot_crystall -= 1
	if player.shot_crystall <= 0 and enemy.shot_crystall <= 0:
		enter_resolution()

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
	var has_stock := false
	for count in AmmoInventory.stock.values():
		if count > 0:
			has_stock = true
	if has_stock:
		return false
	for chamber in player.revolver.chambers:
		if chamber != null:
			return false
	return true

func change_name_ofLabel():
	if phase == Phase.PREPARATION:
		$Phase.text = "Current Phase is Preparation"
	elif phase == Phase.DUEL:
		$Phase.text = "Current Phase is Duel"
	elif phase == Phase.RESOLUTION:
		$Phase.text = "Current Phase is Resolution"
	elif phase == Phase.AFTERMATH:
		$Phase.text = "Current Phase is Rest"
		
