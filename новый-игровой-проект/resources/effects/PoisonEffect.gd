class_name PoisonEffect extends StatusEffect

@export var damage_per_tick: float = 3.0
@export var duration_turns: int = 3

func apply(target: Duelist, shooter: Duelist) -> void:
	target.active_effects.append({"effect": self, "turns_left": duration_turns})

func get_remaining_tick_damage(turns_left: int) -> float:
	return damage_per_tick * turns_left
