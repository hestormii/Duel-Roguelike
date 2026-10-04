class_name ItemEffects extends Resource


func modify_accuracy(base_chance: float, shooter: Duelist, body_part: StringName) -> float:
	return base_chance

func modify_damage(base_damage: float, shooter: Duelist, target: Duelist) -> float:
	return base_damage

func on_use(user: Duelist) -> void:
	pass
