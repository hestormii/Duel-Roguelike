class_name BleedEffect extends StatusEffect

@export var damage_per_tick: float = 3.0
@export var duration_turns: int = 5
@export var potency: int = 0

func apply(target: Duelist, shooter: Duelist) -> void:
	target.active_effects.append({"effect": self, "bleed_turns_left": duration_turns, "potency": potency})
