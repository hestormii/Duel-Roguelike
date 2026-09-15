class_name Duelist extends Node3D

@export var max_health: float = 100.0
var current_health: float = max_health
signal died(who: Duelist)
var action_crystall: int = 0
var shot_crystall: int = 0
@export var base_action_crystall: int = 2
@export var base_shot_crystall: int = 1


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

func pass_the_turn():
	action_crystall -= 1
