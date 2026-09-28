extends Duelist


#не трогать переменные(радиактивно)
@onready var camera_3d: Camera3D = $Camera3D
@onready var at_pistol: Marker3D = $Positions/at_pistol
@onready var at_head: Marker3D = $Positions/at_head
@onready var at_suitcase: Marker3D = $Positions/at_suitcase
@onready var hand: Area3D = $hand
@onready var revolver: Node3D = $hand/revolver
@export var pitch_limit_deg: float = 12.0
@export var yaw_limit_deg: float = 8.0
@export var aim_sensitivity: float = 0.05
@export var starting_bullet: BulletData
@export var starting_bullet_count: int = 6
@onready var duel_manager = get_node("../DuelManager")
@onready var body_part_aim: Control = $UI/BodyPartAim
@onready var Head: Button = $UI/BodyPartAim/head/Head
@onready var body_aim: Button = $UI/BodyPartAim/Body/body
@onready var hand_aim: Button = $UI/BodyPartAim/Hand/hand
@onready var progress_bar: ProgressBar = $UI/ProgressBar
@onready var suitcase: Node3D = $suitcase
@onready var head: Marker3D = $Positions/head
@onready var vision: RayCast3D = $Vision
@export var move_speed = 4
var gravity = -5
var view = View.HEAD
@onready var money: Label = $UI/Money
var look_rotation : Vector2
@export var look_speed : float = 0.002
@onready var looking_at: Label = $UI/looking_at
@onready var looking_for_gravity: RayCast3D = $lookingForGravity
@onready var shop: Node3D = $"../Shop"
@onready var second: Node3D = $"../Second"
@onready var actions_crystals: Label = $UI/Label
@onready var statuses: GridContainer = $UI/Statuses
var bob_time := 0.0
var bob_offset := 0.0
@export var bob_frequency: float = 8.0
@export var bob_amplitude: float = 0.04
@onready var barrel_scene: Control = $UI/BarrelScene
const EFFECT_ICON_SCENE := preload("res://resources/effects/effectsStuff/EffectInUiSprite.tscn")
@onready var walking_sounds: AudioStreamPlayer3D = $AudioStreamPlayer3D
var velocity = Vector3.ZERO


enum View {
	HEAD,
	PISTOL,
	SUITCASE
}

var state = States.Free

enum States {
	Free,
	Locked,
	Shop
}

var aim_offset := Vector2.ZERO

func _ready() -> void:
	camera_3d.global_position = at_head.global_position
	AmmoInventory.add(starting_bullet, starting_bullet_count)
	revolver.reload()
	body_part_aim.hide()
	progress_bar.max_value = max_health
	vision.enabled = false
	looking_at.hide()
	statuses.hide()
	revolver.chambers_changed.connect(barrel_scene.refresh)

func _unhandled_input(event: InputEvent) -> void:
	if state == States.Free and event is InputEventMouseMotion:
		rotate_look(event.relative)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("CheatMoney"):
		ItemInventory.money += 100000
	money.text = str(ItemInventory.money)
	progress_bar.value = current_health
	chage_view()
	if state == States.Locked:
		refresh_status_icons()
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
	if state == States.Free:
		state_is_free(delta)
		if vision.is_colliding():
			var collider = vision.get_collider()
			if collider.is_in_group("SecondDoor"):
				looking_at.text = "Second"
				looking_at.show()
				if Input.is_action_just_pressed("Interact"):
					enter_shop_state()
					second.show()
					second.change_to_second()
					looking_at.hide()
					state_is_shop()
			elif collider.is_in_group("ShopDoor"):
				looking_at.text = "Shop"
				looking_at.show()
				if Input.is_action_just_pressed("Interact"):
					enter_shop_state()
					shop.show()
					shop.change_to_shop()
					looking_at.hide()
					state_is_shop()
		else:
			looking_at.hide()
	if state == States.Shop:
		state_is_shop()

func chage_view():
	if state == States.Locked:
		if Input.is_action_just_pressed("WheelUp") and view == View.HEAD:
			camera_3d.global_position = at_pistol.global_position
			view = View.PISTOL
			print(revolver.chambers)
		elif Input.is_action_just_pressed("WheelDown") and view == View.PISTOL:
			camera_3d.global_position = at_head.global_position
			view = View.HEAD
		elif Input.is_action_just_pressed("turn right") and view == View.HEAD:
			camera_3d.global_position = at_suitcase.global_position
			camera_3d.rotate_y(-PI/2)
			view = View.SUITCASE
			suitcase.open()
		elif Input.is_action_just_pressed("turn left") and view == View.SUITCASE:
			camera_3d.global_position = at_head.global_position
			camera_3d.rotate_y(PI/2)
			view = View.HEAD

func change_DuelState_of_player():
	if state == States.Locked:
		state = States.Free
		print("free")
	elif state == States.Free:
		state = States.Locked
		revolver.chambers_changed.connect(barrel_scene.refresh)
		print("locked")

func enter_shop_state() -> void:
	state = States.Shop
	print("shop")

func exit_shop_state() -> void:
	state = States.Free
	print("free")

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

func state_is_free(delta: float):
	actions_crystals.hide()
	progress_bar.hide()
	looking_at.show()
	statuses.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	look_rotation.y = rotation.y
	look_rotation.x = rotation.x
	suitcase.hide()
	hand.hide()
	vision.enabled = true
	camera_3d.global_position = head.global_position
	var direction = Input.get_vector("left", "right", "up", "down")
	var move_dir := (transform.basis * Vector3(direction.x, 0, direction.y)).normalized()
	if looking_for_gravity.is_colliding():
		velocity.y = 0.0
		global_transform.origin.y = looking_for_gravity.get_collision_point().y
	else:
		velocity.y += gravity * delta
	if move_dir:
		velocity.x = move_dir.x * move_speed
		velocity.z = move_dir.z * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
		velocity.z = move_toward(velocity.z, 0, move_speed)
	global_transform.origin += velocity * delta
	_apply_camera_bob(delta, direction.length() > 0.1)

func _apply_camera_bob(delta: float, is_moving: bool) -> void:
	if is_moving:
		bob_time += delta * bob_frequency
	var target_offset := sin(bob_time) * bob_amplitude if is_moving else 0.0
	bob_offset = lerp(bob_offset, target_offset, clamp(10.0 * delta, 0.0, 1.0))
	camera_3d.position.y += bob_offset

func refresh_status_icons() -> void:
	for child in statuses.get_children():
		child.queue_free()
	for entry in active_effects:
		var icon_node = EFFECT_ICON_SCENE.instantiate()
		statuses.add_child(icon_node)
		icon_node.setup(entry["effect"].icon, str(entry["turns_left"]), str(entry["potency"]))

func state_is_shop():
	looking_at.hide()
	progress_bar.hide()
	actions_crystals.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func state_is_locked():
	bob_time = 0.0
	bob_offset = 0.0
	statuses.show()
	actions_crystals.show()
	progress_bar.show()
	looking_at.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	suitcase.show()
	hand.show()
	camera_3d.global_position = at_head.global_position
	rotation.y = PI / 2

func rotate_look(rot_input: Vector2):
	look_rotation.x -= rot_input.y * look_speed
	look_rotation.x = clamp(look_rotation.x, deg_to_rad(-85), deg_to_rad(85))
	look_rotation.y -= rot_input.x * look_speed
	transform.basis = Basis()
	rotate_y(look_rotation.y)
	camera_3d.rotation.x = look_rotation.x


func _on_self_pressed() -> void:
	duel_manager.player_queue_shot("Self")
