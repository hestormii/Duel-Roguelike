extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(BulletTypes.all_bullets.pick_random().display_name)
