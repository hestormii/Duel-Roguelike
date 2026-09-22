extends Duelist

var stats: BountyData
@onready var label_3d: Label3D = $Label3D

func _ready() -> void:
	max_health = randi_range(125, 150)
	super._ready()
	current_health = max_health




func _process(delta: float) -> void:
	label_3d.text = str(current_health)
