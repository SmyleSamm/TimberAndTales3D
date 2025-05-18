class_name SwitchUIButton extends Button

@export var nextUI: Control
@export var currentUI: Control
@export var previousUI: Control

func _ready() -> void:
	pressed.connect(onPressed)

func onPressed() -> void:
	#close currentUI (only when switching UIs)
	if currentUI:
		World.getCurrentPlayer().closeUI(currentUI)
	
	#switch UI to next or previous UI
	if nextUI:
		World.getCurrentPlayer().openUI(nextUI)
	elif previousUI:
		World.getCurrentPlayer().openUI(previousUI)
	
	#if no current UI -> close game
	elif not currentUI:
		World.getCurrentPlayer().quit()
