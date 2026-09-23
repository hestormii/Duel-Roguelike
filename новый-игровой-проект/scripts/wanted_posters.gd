extends Control

signal bounty_chosen(bounty: BountyData,  reward: int, self_name: String)

const POSTER_SCENE := preload("res://testing out/wanted_poster.tscn")
@onready var grid: GridContainer = $GridContainer
const CARD_COUNT := 3
@export var base_enemy_gen: BountyData


func _ready() -> void:
	populate()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("exit"):
		queue_free()

func populate() -> void:
	for child in grid.get_children():
		child.queue_free()
	var pool := base_enemy_gen.possible_names.duplicate()
	for i in min(CARD_COUNT, pool.size()):
		var name = base_enemy_gen.roll_display_name()
		var reward = base_enemy_gen.roll_reward()
		var poster = POSTER_SCENE.instantiate()
		grid.add_child(poster)
		poster.setup(name, "x%d" % reward, {"bounty": base_enemy_gen, "reward": reward, "bounty_name": name})
		poster.chosen.connect(_on_bounty_poster_chosen)


func _on_bounty_poster_chosen(payload: Dictionary) -> void:
	bounty_chosen.emit(payload["bounty"], payload["reward"], payload["bounty_name"])
	print("smth")
