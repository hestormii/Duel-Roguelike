extends Control


signal chosen(payload: Variant)

@onready var name_label: Label = $Name
@onready var subtitle_label: Label = $reward
@onready var payload: Variant

@onready var stuff: Array = [
	$NinePatchRect,
	$Name,
	$reward,
	$Wanted,
	$ColorRect
]

func setup(title: String, subtitle: String, data: Variant) -> void:
	name_label.text = title
	subtitle_label.text = subtitle
	payload = data
	pivot_offset = size / 2.0
	_start_sway()

func _start_sway() -> void:
	var tween := create_tween().set_loops()
	tween.tween_property(self, "rotation_degrees", 1.0, 1.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "rotation_degrees", -1.0, 1.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _on_color_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		chosen.emit(payload)
		for i in stuff.size():
			stuff[i].hide()
