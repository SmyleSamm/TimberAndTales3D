extends Control

@export var tool: Tool
@onready var sprite: TextureRect = $Sprite3D

func switchTool(tool: Item) -> void:
	#self.tool = tool
	sprite.texture = tool.icon
