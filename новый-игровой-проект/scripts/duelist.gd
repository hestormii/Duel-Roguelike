class_name Duelist extends Node3D

@export var max_health: float = 100.0
var current_health: float = max_health
signal died(who: Duelist)
var action_crystall: int = 0
var shot_crystall: int = 0
@export var base_action_crystall: int = 2
@export var base_shot_crystall: int = 1
var queued_shots: Array[StringName] = []
var loaded_bullets: Array[BulletData] = []
@export var _name: String
var active_effects: Array[Dictionary] = []

func _ready() -> void:
	current_health = max_health

func take_damage(amount: float) -> void:
	current_health = max(0.0, current_health - amount)
	print("current health: ", current_health)
	if current_health <= 0.0:
		die()

func die() -> void:
	died.emit(self)
	queue_free()

func heal(amount: float) -> void:
	current_health = clamp(current_health + amount, 0.0, max_health)
	print("healed to: ", current_health)

func reset_crystalls():
	action_crystall = base_action_crystall
	shot_crystall = base_shot_crystall

func pass_the_turn(amount: int):
	action_crystall -= amount
	for entry in active_effects.duplicate():
		if entry["effect"] is BleedEffect:
			take_damage(entry["effect"].damage_per_tick)
			entry["bleed_turns_left"] -= 1
			if entry["bleed_turns_left"] <= 0:
				active_effects.erase(entry)


func queue_shot(body_part: StringName) -> bool:
	if shot_crystall <= 0:
		return false
	queued_shots.append(body_part)
	shot_crystall -= 1
	return true

func clear_queued_shots() -> void:
	queued_shots.clear()

func load_bullets(bullet: BulletData, amount: int) -> void:
	for i in amount:
		loaded_bullets.append(bullet)

func pop_bullet() -> BulletData:
	if loaded_bullets.is_empty():
		return null
	return loaded_bullets.pop_front()

func has_bullets() -> bool:
	return not loaded_bullets.is_empty()

func tick_effects() -> void:
	for entry in active_effects.duplicate():
		if entry["effect"] is not BleedEffect:
			if entry["effect"] is PoisonEffect:
				take_damage(entry["effect"].damage_per_tick)
			if entry["effect"] is SleepEffect:
				pass_the_turn(entry["effect"].amount)
				print("Sleeping")
			entry["turns_left"] -= 1
			if entry["turns_left"] <= 0:
				active_effects.erase(entry)
