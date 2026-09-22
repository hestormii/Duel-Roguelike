class_name LowHPDamageEffect extends StatusEffect

@export var damage_mult: int = 1
@export var base_damame: int = 0

func modify_damage(base_damage: float, shooter: Duelist, target: Duelist) -> float:
	if shooter.current_health <= shooter.max_health / 2:
		var multiplied_damage = base_damame * damage_mult
		return multiplied_damage
	return base_damage
