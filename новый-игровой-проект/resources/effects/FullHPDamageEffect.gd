class_name FullHPDamageEffect extends StatusEffect

@export var min_damage: float = 5.0
@export var max_damage: float = 15.0

func modify_damage(base_damage: float, shooter: Duelist, target: Duelist) -> float:
	if target.current_health == target.max_health:
		return max_damage
	return min_damage
