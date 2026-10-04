class_name FilledChamberDamageItem extends ItemEffects


@export var damage_per_filled_chamber: float = 1.0

func modify_damage(base_damage: float, shooter: Duelist, target: Duelist) -> float:
	var filled := shooter.chamber_count() - shooter.empty_chamber_count()
	return base_damage + (filled * damage_per_filled_chamber)
