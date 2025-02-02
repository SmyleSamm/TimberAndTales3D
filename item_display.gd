class_name ItemDisplay extends Control

@export var recource_sprite: Texture2D
@export var recource_amount: int

@onready var sprite: TextureRect = $HBoxContainer/sprite
@onready var amount: Label = $HBoxContainer/amount

func _ready() -> void:
	if sprite:
		sprite.texture = recource_sprite
	if amount:
		amount.text = str(recource_amount)
