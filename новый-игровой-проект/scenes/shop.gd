extends Node3D

const WANTED_POSTERS = preload("res://scenes/wanted_posters.tscn")
@onready var ui: Control = $UI
@onready var camera_3d: Camera3D = $Camera3D
var active: bool = false
@onready var player_test: Duelist = $"../PlayerTest"
var steps: int = 0
@onready var shelves_pos: Marker3D = $shelves/ShelvesPos
@onready var original_pos: Marker3D = $Room/Original_pos
@onready var wanted_board_pos: Marker3D = $shelves/WantedBoardPos

@onready var bullet_sprites: Array[Sprite3D] = [
	$shelves/bulletsOnDisplay/Sprite3D2,
	$shelves/bulletsOnDisplay/Sprite3D3,
	$shelves/bulletsOnDisplay/Sprite3D4,
	$shelves/bulletsOnDisplay/Sprite3D5,
]
@onready var slot_labels: Array[Label3D] = [
	$shelves/bulletsOnDisplay/Sprite3D2/name,
	$shelves/bulletsOnDisplay/Sprite3D3/name2,
	$shelves/bulletsOnDisplay/Sprite3D4/name3,
	$shelves/bulletsOnDisplay/Sprite3D5/name4
]
@onready var price_labels: Array[Label3D] = [
	$shelves/bulletsOnDisplay/Sprite3D2/price,
	$shelves/bulletsOnDisplay/Sprite3D3/price2,
	$shelves/bulletsOnDisplay/Sprite3D4/price3,
	$shelves/bulletsOnDisplay/Sprite3D5/price4
]
@onready var amount_labels: Array[Label3D] = [
	$shelves/bulletsOnDisplay/Sprite3D2/amount,
	$shelves/bulletsOnDisplay/Sprite3D3/amount2,
	$shelves/bulletsOnDisplay/Sprite3D4/amount3,
	$shelves/bulletsOnDisplay/Sprite3D5/amount4
]
@onready var bullets_on_display: Node3D = $shelves/bulletsOnDisplay

var offered: Array[BulletData] = []
var offered_amounts: Array[int] = []
var offered_price: Array[int] = []


func _ready() -> void:
	bullets_on_display.hide()
	process_mode = Node.PROCESS_MODE_DISABLED
	camera_3d.current = false
	self.hide()
	ui.hide()

func _process(delta: float) -> void:
	camera_pos_and_states()
	if Input.is_action_just_pressed("exit") and steps == 0:
		exit_shop()
	if Input.is_action_just_pressed("exit") and steps == 1:
		steps = 0
		ui.show()
	if Input.is_action_just_pressed("exit") and steps == 2:
		camera_3d.rotate_y(-PI/2)
		steps = 0
		ui.show()

func change_to_shop():
	process_mode = Node.PROCESS_MODE_ALWAYS
	camera_3d.current = true
	active = true
	ui.show()

func exit_shop():
	player_test.exit_shop_state()
	active = false
	camera_3d.current = false
	self.hide()
	ui.hide()
	process_mode = Node.PROCESS_MODE_DISABLED

func camera_pos_and_states():
	if steps == 1:
		camera_3d.global_position = shelves_pos.global_position
	if steps == 2:
		camera_3d.global_position = wanted_board_pos.global_position
	if steps == 0:
		bullets_on_display.hide()
		camera_3d.global_position = original_pos.global_position

func populate() -> void:
	offered.clear()
	offered_amounts.clear()
	offered_price.clear()
	var pool := BulletTypes.all_bullets.duplicate()
	if pool.is_empty():
		return
	for i in slot_labels.size():
		var bullet: BulletData = pool[randi() % pool.size()]
		var amount := randi_range(bullet.pickup_min, bullet.pickup_max)
		var price := randi_range(bullet.price_min, bullet.price_max)
		slot_labels[i].text = bullet.display_name
		amount_labels[i].text = "x%d" % amount
		price_labels[i].text = "$%d" % price
		bullet_sprites[i].texture = bullet.icon
		offered.append(bullet)
		offered_amounts.append(amount)
		offered_price.append(price)


func _on_button_2_pressed() -> void:
	steps = 1
	ui.hide()
	bullets_on_display.show()
	populate()


func _on_button_pressed() -> void:
	steps = 2
	ui.hide()
	camera_3d.rotate_y(PI/2)
	chose_next_target()

func chose_next_target() -> void:
	var poster = WANTED_POSTERS.instantiate()
	add_child(poster)
	poster.populate()
	poster.bounty_chosen.connect(_on_bounty_chosen)

func _on_bounty_chosen(bounty: BountyData, reward: int) -> void:
	PosterInventory.add_poster(bounty, reward)
