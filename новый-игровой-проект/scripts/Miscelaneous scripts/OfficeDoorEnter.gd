extends Area3D

@onready var player_test: Duelist = $"../../../PlayerTest"
@onready var office_marker: Marker3D = $"../../../OfficeMarker"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func go_to_office():
	player_test.global_position = office_marker.global_position
