class_name StatusEffect extends Resource

@export var display_name: String

func apply(target: Duelist, shooter: Duelist) -> void:
	pass

func modify_damage(base_damage: float, shooter: Duelist, target: Duelist) -> float:
	return base_damage
