extends Node3D

const CYLINDER_SIZE := 6
signal fired(bullet: BulletData, hit_result: Dictionary)

@export var trail_scene: PackedScene  # assign bullet_trail.tscn in the Inspector

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
		fired.emit(null, {})
		return

	var from := muzzle.global_position
	var to := from - muzzle.global_transform.basis.z * 100.0
	var query := PhysicsRayQueryParameters3D.create(from, to)
	query.collide_with_areas = true
	query.collide_with_bodies = false

	var result := get_world_3d().direct_space_state.intersect_ray(query)
	var impact_point: Vector3 = result.position if result else to
	_spawn_trail(from, impact_point)

	fired.emit(bullet, result)
	print("pass")

func _spawn_trail(from: Vector3, to: Vector3) -> void:
	if trail_scene == null:
		return
	var trail: MeshInstance3D = trail_scene.instantiate()
	get_tree().current_scene.add_child(trail)
	trail.draw(from, to)
