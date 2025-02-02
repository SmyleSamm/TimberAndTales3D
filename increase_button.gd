extends CraftButton


func _on_pressed() -> void:
	if hasEnoughResources(1):
		recipie.currentModifier += 1
		_update()
