class_name CraftButton extends Button

var ui: Control
var recipie: Recipe

func init(ui: Control, recipie: Recipe) -> void:
	self.ui = ui
	self.recipie = recipie

func getInv() -> Array[Item]:
	return World.getResources()

func hasEnoughResources(modifier: int) -> bool:
	if not getInv():
		return false
	var canCraft: bool = false
	for i in recipie.requirements:
		canCraft = false
		modifier = recipie.currentModifier + modifier
		for n in getInv():
			if i.item.name == n.name:
				canCraft = i.maxCount*modifier <= n.stackSize
		if not canCraft:
			return false
	return true

func _update() -> void:
	ui.update(recipie)
