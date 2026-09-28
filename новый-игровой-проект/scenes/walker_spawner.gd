# crowd_spawner.gd
extends Node3D

@export var walker_scene: PackedScene
@export var street_half_width: float = 1.5
@export var min_wait: float = 1.0
@export var max_wait: float = 4.0
@export var max_walkers: int = 15
@export var group_chance: float = 0.3

@onready var point_a: Marker3D = $"One Point"
@onready var point_b: Marker3D = $"Other point"
@onready var timer: Timer = $Timer
@onready var walkers: Node3D = $Node3D

func _ready() -> void:
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	timer.start(randf_range(min_wait, max_wait))

func _on_timer_timeout() -> void:
	var count := randi_range(2, 3) if randf() < group_chance else 1
	for i in count:
		if walkers.get_child_count() < max_walkers:
			_spawn_walker()
	timer.start(randf_range(min_wait, max_wait))

func _spawn_walker() -> void:
	var ends: Array[Vector3] = [point_a.global_position, point_b.global_position]
	if randf() < 0.5:
		ends.reverse()
	var along := (ends[1] - ends[0]).normalized()
	var side := Vector3(-along.z, 0.0, along.x)
	var lane := side * randf_range(-street_half_width, street_half_width)
	var stagger := along * randf_range(0.0, 1.5)
	var mid := ends[0].lerp(ends[1], randf_range(0.35, 0.65)) + side * randf_range(-street_half_width, street_half_width)
	var path: Array[Vector3] = [ends[0] + lane + stagger, mid, ends[1] + lane]
	var walker = walker_scene.instantiate()
	walkers.add_child(walker)   # into the tree FIRST, then position it
	walker.start(path)
