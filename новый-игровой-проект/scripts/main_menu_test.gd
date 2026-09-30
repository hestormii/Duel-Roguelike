extends Node3D

@onready var tv_play: Area3D = $TVPlay
@onready var tv_load_save: Area3D = $TVLoadSave
@onready var tv_exit: Area3D = $TVExit


func _ready() -> void:
	get_viewport().physics_object_picking = true



func _process(delta: float) -> void:
	pass


func _on_tv_play_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_tree().change_scene_to_file("res://scenes/trenchbroomScenes/combined_maps.tscn")
