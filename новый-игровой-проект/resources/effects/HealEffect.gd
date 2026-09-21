class_name HealEffect extends StatusEffect

@export var amount: float = 5.0
@export var heals_self: bool = false

func apply(target: Duelist, shooter: Duelist) -> void:
	var recipient := shooter if heals_self else target
	recipient.heal(amount)
