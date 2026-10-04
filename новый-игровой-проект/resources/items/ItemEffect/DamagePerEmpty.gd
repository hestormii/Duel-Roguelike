class_name EmptyChamberDamageItem extends ItemEffects


@export var damage_per_empty_chamber: float = 1.0


func modify_damage(base_damage: float, shooter: Duelist, target: Duelist) -> float:
	return base_damage + (shooter.empty_chamber_count() * damage_per_empty_chamber)
