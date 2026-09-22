class_name HealEffect extends StatusEffect

@export var heals_self: bool = false
@export var amount: float = 15.0

func apply(target: Duelist, shooter: Duelist) -> void:
	var recipient := shooter if heals_self else target
	recipient.heal(amount)
