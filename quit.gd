class_name QuitButton extends Button

func _ready() -> void:
	pressed.connect(buttonPressed)

func buttonPressed() -> void:
	#TODO: Ask for validation or smth like that/ quit and save or not type shit
	get_tree().quit()
