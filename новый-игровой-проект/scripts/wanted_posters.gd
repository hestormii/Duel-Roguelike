extends Control

signal bounty_chosen(bounty: BountyData, reward: int, self_name: String)

const POSTER_SCENE := preload("res://testing out/wanted_poster.tscn")
@onready var grid: GridContainer = $GridContainer
const CARD_COUNT := 3

func _ready() -> void:
	populate()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("exit"):
		queue_free()

func populate() -> void:
	for child in grid.get_children():
		child.queue_free()
	
	var bounties := EnemyTypes.get_random_mix()
	
	for bounty in bounties:
		var name = bounty.display_name
		var rolled_reward := bounty.roll_reward()
		var poster = POSTER_SCENE.instantiate()
		grid.add_child(poster)
		poster.setup(
			name,
			"$%d" % rolled_reward,
			{"bounty": bounty, "reward": rolled_reward, "bounty_name": name}
		)
		poster.chosen.connect(_on_bounty_poster_chosen)

func _on_bounty_poster_chosen(payload: Dictionary) -> void:
	bounty_chosen.emit(payload["bounty"], payload["reward"], payload["bounty_name"])
