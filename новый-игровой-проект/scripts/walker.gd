# crowd_walker.gd
extends Node3D

@export var base_speed: float = 1.3
@export var sway_amount: float = 0.25
@export var sway_speed: float = 2.0

var waypoints: Array[Vector3] = []
var speed: float
var sway_phase: float
var t: float = 0.0

func start(path: Array[Vector3]) -> void:
	waypoints = path
	var first: Vector3 = waypoints.pop_front()
	global_position = first   # only valid once we're already in the tree
	speed = base_speed * randf_range(0.8, 1.25)
	sway_phase = randf() * TAU

func _process(delta: float) -> void:
	if waypoints.is_empty():
		queue_free()
		return
	t += delta
	var to_target := waypoints[0] - global_position
	to_target.y = 0.0
	if to_target.length() < 0.3:
		waypoints.pop_front()
		return
	var dir := to_target.normalized()
	var side := Vector3(-dir.z, 0.0, dir.x)
	var sway := sin(t * sway_speed + sway_phase) * sway_amount
	global_position += (dir + side * sway).normalized() * speed * delta
	look_at(global_position + dir, Vector3.UP)
