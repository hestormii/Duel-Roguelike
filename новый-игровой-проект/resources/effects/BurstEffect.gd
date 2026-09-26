class_name BurstEffect extends StatusEffect

func modify_damage(base_damage: float, shooter: Duelist, target: Duelist) -> float:
	var damage_sum: float = 0.0
	var to_remove: Array[Dictionary] = []
	for entry in target.active_effects:
		if entry["effect"].is_negative_effect:
			damage_sum += int(entry["effect"].get_remaining_tick_damage(int(entry["turns_left"])))
			to_remove.append(entry)
	for entry in to_remove:
		target.active_effects.erase(entry)
	if to_remove.is_empty():
		return base_damage
	return damage_sum
