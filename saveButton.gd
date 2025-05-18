class_name SaveButton extends Button

func _ready() -> void:
	pressed.connect(save_pressed)

func save_pressed() -> void:
	SaveGame.saveGame()
