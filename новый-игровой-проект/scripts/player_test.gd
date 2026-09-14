extends Duelist

@onready var camera_3d: Camera3D = $Camera3D
@onready var at_pistol: Marker3D = $Positions/at_pistol
@onready var at_head: Marker3D = $Positions/at_head
var at_head_view: bool = true
@onready var hand: Area3D = $hand
@onready var revolver: Node3D = $hand/Revolver

@export var pitch_limit_deg: float = 12.0
@export var yaw_limit_deg: float = 8.0
@export var aim_sensitivity: float = 0.05
@export var starting_bullet: BulletData
@export var starting_bullet_count: int = 6


var aim_offset := Vector2.ZERO

func _ready() -> void:
	camera_3d.global_position = at_head.global_position
	AmmoInventory.add(starting_bullet, starting_bullet_count)
	revolver.reload()

func _process(_delta: float) -> void:
	chage_view()
	if at_head_view:
		hand.rotation_degrees.y = aim_offset.x
		hand.rotation_degrees.x = aim_offset.y
	if Input.is_action_just_pressed("shoot_placeholder"):
		revolver.shoot()
	if Input.is_action_just_pressed("reload"):
		reload_revolver()

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

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and at_head_view:
		aim_offset.x = clamp(aim_offset.x - event.relative.x * aim_sensitivity, -yaw_limit_deg, yaw_limit_deg)
		aim_offset.y = clamp(aim_offset.y - event.relative.y * aim_sensitivity, -pitch_limit_deg, pitch_limit_deg)

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
