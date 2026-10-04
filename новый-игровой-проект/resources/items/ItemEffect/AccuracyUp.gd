class_name AccuracyUp extends ItemEffects


@export var accuracy_bonus: float = 0.1

func modify_accuracy(base_chance: float, shooter: Duelist, body_part: StringName) -> float:
	return base_chance + accuracy_bonus
