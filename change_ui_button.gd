class_name ChangeUIButton extends Button

@export var changeScene: PackedScene
@export var currentScene: Control

#FIXME: change scene is null when esc -> options -> back

func _ready() -> void:
	print("I am alive")
	pressed.connect(buttonPressed)

func buttonPressed() -> void:
	print(changeScene)
	print(currentScene)
	if changeScene:
		World.getCurrentPlayer().closeUI(currentScene)
		var ui: Control = changeScene.instantiate() as Control
		#TODO: ui needs to be added
		get_tree().root.add_child(ui)
		if ui:
			print(ui.visible)
			World.getCurrentPlayer().openUI(ui)
			print(ui.visible)
		else:
			print("UI could not be loaded")
	else:
		print("no scene to change to")
		World.getCurrentPlayer().closeUI(currentScene)
