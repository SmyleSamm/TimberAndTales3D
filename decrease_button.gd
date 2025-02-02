extends CraftButton


func _on_pressed() -> void:
	if recipie.currentModifier > 1:
		recipie.currentModifier -= 1
		_update()
