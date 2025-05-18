class_name SaveLoadButton extends Button

@export_enum("save", "load") var mode: String = "save"

func _ready() -> void:
	pressed.connect(onPressed)

func onPressed() -> void:
	if mode == "save":
		SaveGame.saveGame()
	else:
		SaveGame.loadGame()
