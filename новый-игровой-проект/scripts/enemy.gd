extends Duelist

@export var bounty_data: BountyData


func _ready() -> void:
	max_health = randi_range(100, 125)
	super._ready()
	current_health = max_health




func _process(delta: float) -> void:
	pass
