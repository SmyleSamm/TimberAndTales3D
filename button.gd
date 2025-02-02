class_name CraftButton extends Button

var ui: Control
var recipie: Recipe

func init(ui: Control, recipie: Recipe) -> void:
	self.ui = ui
	self.recipie = recipie

func getInv() -> Array[Item]:
	return World.getResources()

func hasEnoughResources() -> bool:
	if not getInv():
		return false
	var canCraft: bool = false
	for i in recipie.requirements:
		canCraft = false
		for n in getInv():
			if i.item.name == n.name:
				canCraft = i.maxCount <= n.stackSize
		if not canCraft:
			return false
	return true
