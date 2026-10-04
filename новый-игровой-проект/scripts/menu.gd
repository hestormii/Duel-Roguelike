extends Control

@onready var player_test: Duelist = $".."


func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_resume_pressed() -> void:
	self.hide()
	player_test.change_Menu_state()


func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu_test.tscn")


func _on_save_pressed() -> void:
	SaveManager.save_game()
