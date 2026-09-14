extends Node3D


const BULLET_PICK = preload("res://scenes/bullet_pick.tscn")
const WANTED_POSTERS = preload("res://scenes/wanted_posters.tscn")



func _process(delta: float) -> void:
	pass

func _on_enemy_test_died(who: Duelist) -> void:
	var instance_the_bl = BULLET_PICK.instantiate()
	add_child(instance_the_bl)
	instance_the_bl.populate()


func _on_player_test_died(who: Duelist) -> void:
	pass # Replace with function body.
