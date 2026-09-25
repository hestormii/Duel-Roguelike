class_name CopyAdjacentEffect extends StatusEffect

func apply(target: Duelist, shooter: Duelist) -> void:
	if shooter.loaded_bullets.is_empty():
		return
	var adjacent: BulletData = shooter.loaded_bullets[0]
	if adjacent.id == "CopyBL":
		pass
	else:
		for effect in adjacent.effects:
			effect.apply(target, shooter)
