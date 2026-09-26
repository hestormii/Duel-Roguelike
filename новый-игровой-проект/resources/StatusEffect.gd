class_name StatusEffect extends Resource

@export var display_name: String
@export var icon: Texture2D

func apply(target: Duelist, shooter: Duelist) -> void:
	pass

func modify_damage(base_damage: float, shooter: Duelist, target: Duelist) -> float:
	return base_damage
