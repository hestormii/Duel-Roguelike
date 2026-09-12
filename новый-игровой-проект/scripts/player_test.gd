extends Node3D

@onready var camera_3d: Camera3D = $Camera3D
@onready var at_pistol: Marker3D = $Positions/at_pistol
@onready var at_head: Marker3D = $Positions/at_head
var at_head_view: bool = true


func _ready() -> void:
	camera_3d.global_position = at_head.global_position

func _process(_delta: float) -> void:
	chage_view()


func chage_view():
	if Input.is_action_just_pressed("WheelUp") and at_head_view == true:
		camera_3d.global_position = at_pistol.global_position
		at_head_view = false
	elif Input.is_action_just_pressed("WheelDown") and at_head_view == false:
		camera_3d.global_position = at_head.global_position
		at_head_view = true
