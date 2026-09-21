extends Node3D

@onready var ui: Control = $UI
@onready var camera_3d: Camera3D = $Camera3D
var active: bool = false
@onready var player_test: Duelist = $"../PlayerTest"
var steps: int = 0
@onready var orig_pos: Marker3D = $orig_pos
@onready var counter_pos: Marker3D = $counter_pos
@onready var poster_slots: Array[Control] = [
	$PosterUI/PosterOne,
	$PosterUI/PosterTwo,
	$PosterUI/PosterThree,
]
@onready var poster_name_labels: Array[Label] = [
	$PosterUI/PosterOne/ColorRect/Name,
	$PosterUI/PosterTwo/ColorRect/Name,
	$PosterUI/PosterThree/ColorRect/Name
]
@onready var poster_reward_labels: Array[Label] = [
	$PosterUI/PosterOne/ColorRect/reward,
	$PosterUI/PosterTwo/ColorRect/reward,
	$PosterUI/PosterThree/ColorRect/reward
]
@onready var test_world: Node3D = $".."
@onready var poster_ui: Control = $PosterUI



func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	camera_3d.current = false
	self.hide()
	ui.hide()
	poster_ui.hide()

func _process(delta: float) -> void:
	camera_pos_and_states()
	if Input.is_action_just_pressed("exit") and steps == 0:
		exit_second()
	if Input.is_action_just_pressed("exit") and steps == 1:
		camera_3d.rotate_x(PI/2)
		steps = 0
		ui.show()

func refresh_posters() -> void:
	for i in poster_slots.size():
		if i < PosterInventory.held_posters.size():
			var entry: Dictionary = PosterInventory.held_posters[i]
			var bounty: BountyData = entry["bounty"]
			poster_name_labels[i].text = bounty.display_name
			poster_reward_labels[i].text = "$%d" % entry["reward"]
			poster_slots[i].show()
		else:
			poster_slots[i].hide()


func _on_poster_slot_gui_input(event: InputEvent, index: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if index >= PosterInventory.held_posters.size():
			return
		var entry: Dictionary = PosterInventory.held_posters[index]
		PosterInventory.remove_poster(index)
		steps = 0
		camera_3d.rotate_x(PI/2)
		exit_second()
		test_world.start_duel_with(entry["bounty"], entry["reward"])

func change_to_second():
	camera_3d.current = true
	active = true
	ui.show()
	process_mode = Node.PROCESS_MODE_ALWAYS

func exit_second():
	player_test.exit_shop_state()
	active = false
	camera_3d.current = false
	self.hide()
	ui.hide()
	poster_ui.hide()
	process_mode = Node.PROCESS_MODE_DISABLED

func camera_pos_and_states():
	if steps == 1:
		camera_3d.global_position = counter_pos.global_position
		poster_ui.show()
		refresh_posters()
	if steps == 0:
		camera_3d.global_position = orig_pos.global_position
		poster_ui.hide()


func _on_button_pressed() -> void:
	steps = 1
	ui.hide()
	camera_3d.rotate_x(-PI/2)

func _on_color_rect_gui_input(event: InputEvent, extra_arg_0: int) -> void:
	_on_poster_slot_gui_input(event, extra_arg_0)
