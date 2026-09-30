extends Node3D

@onready var player_test: Duelist = $"../../PlayerTest"
@onready var apartment_enter_pos: Marker3D = $ApartmentEnterPos
@onready var exit_marker: Marker3D = $"../ExitMarker"


func go_to_corridor():
	player_test.global_position = apartment_enter_pos.global_position
