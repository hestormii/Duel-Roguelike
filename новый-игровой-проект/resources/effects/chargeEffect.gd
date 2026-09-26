class_name ChargeEffect extends StatusEffect

@export var damage_buff_by_potency_amount: float = 3.0
@export var potency: int = 0
@export var duration_turns: int = 3

func apply(target: Duelist, shooter: Duelist) -> void:
	target.active_effects.append({"effect": self, "turns_left": duration_turns, "potency": potency})

func modify_damage(base_damage: float, shooter: Duelist, target: Duelist) -> float:
	for entry in shooter.active_effects.duplicate():
		if entry["effect"] is ChargeEffect:
			var charged_damage = int(entry["potency"]) * damage_buff_by_potency_amount
			return base_damage + charged_damage
	return base_damage
