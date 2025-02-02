extends StaticBody3D

@export var tool: Tool
@onready var sprite: Sprite3D = $Sprite3D

func switchTool(tool: Tool) -> void:
	self.tool = tool
	sprite.texture = tool.icon
