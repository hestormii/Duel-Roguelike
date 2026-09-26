extends Control

@onready var chamber_icons: Array[Sprite2D] = [
	$Chamber1, $Chamber2, $Chamber3, $Chamber4, $Chamber5, $Chamber6
]


func refresh(chambers: Array[BulletData]) -> void:
	for i in chamber_icons.size():
		if i < chambers.size() and chambers[i] != null:
			chamber_icons[i].texture = chambers[i].back_icon
			chamber_icons[i].show()
		else:
			chamber_icons[i].hide()

func rotate_self():
	if Input.is_action_just_pressed("Interact"):
		self.rotation += PI / 3
