class_name SleepEffect extends StatusEffect

@export var amount: int = 2
@export var duration_turns: int = 1
@export var potency: int = 0


func apply(target: Duelist, shooter: Duelist) -> void:
	target.active_effects.append({"effect": self, "turns_left": duration_turns, "potency": potency})
