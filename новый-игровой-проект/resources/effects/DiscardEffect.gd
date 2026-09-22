class_name DiscardEffect extends StatusEffect

@export var damage_per_discarded: float = 3.5

func modify_damage(base_damage: float, shooter: Duelist, target: Duelist) -> float:
	var discarded := shooter.loaded_bullets.size()
	shooter.loaded_bullets.clear()
	return base_damage + (discarded * damage_per_discarded)
