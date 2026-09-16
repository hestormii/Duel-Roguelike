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

func pop_bullet() -> BulletData:
	var bullet: BulletData = chambers[current_index]
	chambers[current_index] = null
	current_index = (current_index + 1) % CYLINDER_SIZE
	return bullet
	
	if bullet == null:
		fired.emit(null, {})
		return
