extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var bullet_labels: Array[Label3D] = [
	$Bullets/Label3D,
	$Bullets/Label3D2,
	$Bullets/Label3D3,
	$Bullets/Label3D4,
	$Bullets/Label3D5
]
@onready var spot_light_3d: SpotLight3D = $SpotLight3D

func _ready() -> void:
	spot_light_3d.hide()

func open() -> void:
	animation_player.play("upper caseAction")
	update_bullet_display()
	spot_light_3d.show()

func update_bullet_display() -> void:
	if AmmoInventory.stock.is_empty():
		bullet_labels[0].text = "Empty"
		for i in range(1, bullet_labels.size()):
			bullet_labels[i].text = ""
		return
	var index := 0
	for bullet in AmmoInventory.stock:
		if index >= bullet_labels.size():
			break
		var count: int = AmmoInventory.stock[bullet]
		bullet_labels[index].text = "%s x%d" % [bullet.display_name, count]
		index += 1
	for i in range(index, bullet_labels.size()):
		bullet_labels[i].text = ""
