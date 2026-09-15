class_name Duelist extends Node3D

@export var max_health: float = 100.0
var current_health: float = max_health
signal died(who: Duelist)


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

func heal(amount: float):
	current_health = max(0.0, current_health + amount)
	print("healed: ", amount)
	if current_health > max_health:
		current_health = max_health
