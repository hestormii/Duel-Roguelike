extends Node3D


@onready var bullets: Node3D = $Bullets
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label_3d: Label3D = $Bullets/Label3D
@onready var BulletInventory: Array = [
	$Bullets/Label3D,
	$Bullets/Label3D2,
	$Bullets/Label3D3,
	$Bullets/Label3D4,
	$Bullets/Label3D5
]



func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func open() -> void:
	animation_player.play("upper caseAction")
	if AmmoInventory.stock.is_empty():
		print("suitcase is empty")
		return
	for bullet in AmmoInventory.stock:
		print(bullet.display_name, " x", AmmoInventory.stock[bullet])
