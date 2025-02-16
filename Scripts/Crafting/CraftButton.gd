class_name CraftButton extends Button

var ui: Control
var recipie: Recipe

func init(ui: Control, recipie: Recipe) -> void:
	self.ui = ui
	self.recipie = recipie

func getInv() -> Array[Array]:
	return World.getPlayerResources()

func hasEnoughResources(modifier: int) -> bool:
	for i in recipie.requirements:
		var canCraft: bool = false
		var currentModifier: int = recipie.currentModifier + modifier
		for n in getInv():
			if i.item == n[0]:
				canCraft = i.maxCount * currentModifier <= n[1]
		if not canCraft:
			return false
	return true

func _update() -> void:
	ui.update(recipie)
