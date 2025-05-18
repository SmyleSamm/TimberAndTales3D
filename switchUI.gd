extends Button

@export var nextUI: Control
@export var currentUI: Control
@export var previousUI: Control

func _ready() -> void:
	pressed.connect(onPressed)

func onPressed() -> void:
	if currentUI:
		World.getCurrentPlayer().closeUI(currentUI)
	
	if nextUI:
		World.getCurrentPlayer().openUI(nextUI)
	elif previousUI:
		World.getCurrentPlayer().openUI(previousUI)
	elif not currentUI:
		World.getCurrentPlayer().quit()
