extends Control

@onready var sprite: Sprite2D = $Sprite2D
@onready var count: Label = $count
@onready var potency: Label = $potency
@onready var duelist: Duelist

func setup(icon: Texture2D, text: String) -> void:
	sprite.texture = icon
	count.text = text
