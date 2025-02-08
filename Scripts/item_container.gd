extends Control

@export var recource_sprite1: Texture2D
@export var recource_amount1: int
@export var recource_sprite2: Texture2D
@export var recource_amount2: int
@export var recource_sprite3: Texture2D
@export var recource_amount3: int
@export var recource_sprite4: Texture2D
@export var recource_amount4: int
@export var recource_sprite5: Texture2D
@export var recource_amount5: int
@export var recource_sprite6: Texture2D
@export var recource_amount6: int

func _ready() -> void:
	print(getRecources())

func getRecources() -> Array:
	var newArray = []
	if recource_amount1 != 0:
		newArray.append(recource_amount1)
	if recource_amount2 != 0:
		newArray.append(recource_amount2)
	if recource_amount3 != 0:
		newArray.append(recource_amount3)
	if recource_amount4 != 0:
		newArray.append(recource_amount4)
	if recource_amount5 != 0:
		newArray.append(recource_amount5)
	if recource_amount6 != 0:
		newArray.append(recource_amount6)
	return newArray
