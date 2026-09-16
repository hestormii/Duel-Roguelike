extends Duelist

@onready var camera_3d: Camera3D = $Camera3D
@onready var at_pistol: Marker3D = $Positions/at_pistol
@onready var at_head: Marker3D = $Positions/at_head
var at_head_view: bool = true
@onready var hand: Area3D = $hand
@onready var revolver: Node3D = $hand/revolver

@export var pitch_limit_deg: float = 12.0
@export var yaw_limit_deg: float = 8.0
@export var aim_sensitivity: float = 0.05
@export var starting_bullet: BulletData
@export var starting_bullet_count: int = 6
@onready var duel_manager = get_node("../DuelManager")
@onready var body_part_aim: Control = $UI/BodyPartAim
@onready var head_aim: Button = $UI/BodyPartAim/Head
@onready var body_aim: Button = $UI/BodyPartAim/Body
@onready var hand_aim: Button = $UI/BodyPartAim/Hand
@onready var progress_bar: ProgressBar = $UI/ProgressBar


var aim_offset := Vector2.ZERO

func _ready() -> void:
	camera_3d.global_position = at_head.global_position
	AmmoInventory.add(starting_bullet, starting_bullet_count)
	revolver.reload()
	body_part_aim.hide()
	progress_bar.max_value = max_health

func _process(_delta: float) -> void:
	chage_view()
	if at_head_view:
		hand.rotation_degrees.y = aim_offset.x
		hand.rotation_degrees.x = aim_offset.y
	if Input.is_action_just_pressed("shoot_placeholder"):
		duel_manager.player_react()
	if duel_manager.phase == duel_manager.Phase.TARGETING:
		body_part_aim.show()
	else:
		body_part_aim.hide()
	if Input.is_action_just_pressed("reload"):
		reload_revolver()
	if Input.is_action_just_pressed("action pass"):
		duel_manager.player_passed()
	if duel_manager.phase == duel_manager.Phase.PREPARATION:
		$UI/Label.text = "Action crystal aviable: " + str(action_crystall)
	if duel_manager.phase == duel_manager.Phase.DUEL:
		$UI/Label.text = "Shot crystal aviable: " + str(shot_crystall)
	progress_bar.value = current_health


func chage_view():
	if Input.is_action_just_pressed("WheelUp") and at_head_view == true:
		camera_3d.global_position = at_pistol.global_position
		at_head_view = false
		_reset_aim()
		print(revolver.chambers)
	elif Input.is_action_just_pressed("WheelDown") and at_head_view == false:
		camera_3d.global_position = at_head.global_position
		at_head_view = true

func _reset_aim() -> void:
	aim_offset = Vector2.ZERO
	hand.rotation_degrees.y = 0.0
	hand.rotation_degrees.x = 0.0

func pop_bullet() -> BulletData:
	return revolver.pop_bullet()

func has_bullets() -> bool:
	for chamber in revolver.chambers:
		if chamber != null:
			return true
	for count in AmmoInventory.stock.values():
		if count > 0:
			return true
	return false

func _on_revolver_fired(bullet: BulletData, hit_result: Dictionary) -> void:
	if bullet == null:
		return
	if hit_result.is_empty():
		return
	var hit_area: Area3D = hit_result.collider
	var multiplier := 1.0
	for group_name in ["Head", "Body", "Hand"]:
		if hit_area.is_in_group(group_name):
			multiplier = {"Head": 5.0, "Body": 2.0, "Hand": 0.5}[group_name]
			break
	var final_damage := bullet.damage * multiplier
	hit_area.owner.take_damage(final_damage)

func reload_revolver():
		revolver.reload()
		print(AmmoInventory.stock)


func _on_head_pressed() -> void:
	duel_manager.player_queue_shot("Head")
func _on_body_pressed() -> void:
	duel_manager.player_queue_shot("Body")
func _on_hand_pressed() -> void:
	duel_manager.player_queue_shot("Hand")
