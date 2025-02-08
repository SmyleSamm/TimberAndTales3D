extends Node3D

@onready var sprite: Sprite3D = $CSGBox3D/Sprite3D

func switchTool(tool: Tool) -> void:
	sprite.texture = tool.icon
