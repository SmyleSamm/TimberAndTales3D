class_name Crafting extends StaticBody3D

@export var ui: Control

func _ready() -> void:
	ui.hide()
	
func getUI() -> Control:
	return ui 
