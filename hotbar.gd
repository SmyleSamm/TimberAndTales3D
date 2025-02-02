extends CanvasLayer

@onready var gC: GridContainer = $GridContainer
@onready var player: Player = $".."
@onready var item: StaticBody3D = $Item

var activeSlot: Slot

func _ready() -> void:
	for i in range(9):
		var slot: Slot = Slot.new()
		var tool: Tool = preload("res://CraftingSystem/Items/Tools/hand.tres")
		slot.item = tool
		gC.add_child(slot)
	getSlots()[0].item = preload("res://CraftingSystem/Items/Tools/axe.tres")
	getSlots()[0].icon = getSlots()[0].item.icon
	activateSlot(1)
	
func getSlots() -> Array:
	return gC.get_children()

func activateSlot(slotID: int) -> void:
	var slot: Slot = getSlots()[slotID-1]
	activeSlot = slot
	if slot.item is Tool:
		item.switchTool(slot.item)
