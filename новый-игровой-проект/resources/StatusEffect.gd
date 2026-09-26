class_name StatusEffect extends Resource

@export var Effectdisplay_name: String
@export var icon: Texture2D
@export var is_negative_effect: bool = true

func apply(target: Duelist, shooter: Duelist) -> void:
	pass

func modify_damage(base_damage: float, shooter: Duelist, target: Duelist) -> float:
	return base_damage

func get_remaining_tick_damage(turns_left: int) -> float:
	return 0.0
