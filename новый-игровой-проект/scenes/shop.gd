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
@onready var button_3: Button = $Button3

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
var reroll_price: int = 10

func _ready() -> void:
	get_viewport().physics_object_picking = true
	bullets_on_display.hide()
	process_mode = Node.PROCESS_MODE_DISABLED
	camera_3d.current = false
	self.hide()
	ui.hide()
	button_3.hide()

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
	button_3.text = "reroll shop for " + str(reroll_price)

func change_to_shop():
	process_mode = Node.PROCESS_MODE_ALWAYS
	camera_3d.current = true
	active = true
	ui.show()
	populate()

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
		button_3.hide()

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
	button_3.show()


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

func _on_bounty_chosen(bounty: BountyData, reward: int, self_name: String) -> void:
	PosterInventory.add_poster(bounty, reward, self_name)


func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int, extra_arg_0: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_buy_bullet(extra_arg_0)


func _buy_bullet(index: int) -> void:
	if index >= offered.size():
		return
	var bullet: BulletData = offered[index]
	var price: int = offered_price[index]
	var amount: int = offered_amounts[index]
	if not ItemInventory.spend_money(price):
		print("not enough money")
		return
	AmmoInventory.add(bullet, amount)
	print("bought ", amount, "x ", bullet.display_name, " for $", price)
	bullet_sprites[index].hide()


func _on_button_3_pressed() -> void:
	if ItemInventory.money > reroll_price:
		populate()
		reroll_price = reroll_price * 1.5
		for i in bullet_sprites.size():
			bullet_sprites[i].show()
		ItemInventory.spend_money(reroll_price)
	else: print("Not enough money for reroll")
