extends CraftButton


func _on_pressed() -> void:
	if hasEnoughResources():
		for i in recipie.requirements:
			World.changeResources(i.item, -i.maxCount)
		for i in recipie.item:
			World.changeResources(i.item, i.maxCount)
