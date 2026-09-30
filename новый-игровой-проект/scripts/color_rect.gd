extends ColorRect

func flash(peak: float = 1.0, decay_time: float = 0.12) -> void:
	material.set_shader_parameter("intensity", peak)
	var tween := create_tween()
	tween.tween_method(_set_intensity, peak, 0.0, decay_time).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

func _set_intensity(value: float) -> void:
	material.set_shader_parameter("intensity", value)
