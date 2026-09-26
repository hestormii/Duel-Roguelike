class_name MoreDamaeOnStatusNegativeEffect extends StatusEffect

@export var extra_damage: float = 0
@export var potency: int = 0

func modify_damage(base_damage: float, shooter: Duelist, target: Duelist) -> float:
	for entry in target.active_effects:
		if entry["effect"].is_negative_effect:
			return extra_damage + base_damage
	return base_damage
