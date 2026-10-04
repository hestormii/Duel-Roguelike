class_name ItemData extends Resource

@export var id: StringName
@export var display_name: String
@export var icon: Texture2D
@export var rarity: int
@export var price_min: int = 1
@export var price_max: int = 1
@export var item_type: StringName = "active"
@export var item_effect: Array[ItemEffects] = []
