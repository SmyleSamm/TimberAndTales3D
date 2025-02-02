extends CraftButton


func _on_pressed() -> void:
	if hasEnoughResources(0):
		for i in recipie.requirements:
			World.changeResources(i.item, -i.maxCount*recipie.currentModifier)
		for i in recipie.item:
			World.changeResources(i.item, i.maxCount*recipie.currentModifier)
		recipie.currentModifier = 1
		_update()
