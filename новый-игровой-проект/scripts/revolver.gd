# revolver.gd
extends Node3D

const CYLINDER_SIZE := 6
signal fired(bullet: BulletData, hit_result: Dictionary)

var chambers: Array[BulletData] = []
var current_index: int = 0

@onready var muzzle: Marker3D = $Marker3D

func _ready() -> void:
	chambers.resize(CYLINDER_SIZE)

func reload() -> void:
	for i in CYLINDER_SIZE:
		if chambers[i] == null:
			chambers[i] = AmmoInventory.draw_random()

func shoot() -> void:
	var bullet: BulletData = chambers[current_index]
	chambers[current_index] = null
	current_index = (current_index + 1) % CYLINDER_SIZE

	if bullet == null:
		fired.emit(null, {})  # dry click, no bullet
		return

	var from := muzzle.global_position
	var to := from - muzzle.global_transform.basis.z * 100.0
	var query := PhysicsRayQueryParameters3D.create(from, to)
	query.collide_with_areas = true
	query.collide_with_bodies = false

	var result := get_world_3d().direct_space_state.intersect_ray(query)
	fired.emit(bullet, result)
