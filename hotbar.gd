class_name Hotbar extends Inventory


@onready var gC: GridContainer = $ScrollContainer/GridContainer
@onready var player: Player = $"../.."
@onready var hand: Node3D = $"../../Head/Hand"
@onready var item: Control = $Tool
@onready var inventory: Inventory = $"../Inventory"

var activeSlotID: int
var activeSlot: Slot

func getAttack() -> Attack:
	return activeSlot.getAttack()

func activateSlot(slotID: int) -> void:
	var slot: Slot = getSlot(slotID)
	activeSlotID = slotID
	activeSlot = slot
	slot.grab_focus()
	if slot.item is Tool:
		item.switchTool(slot.item)
		hand.switchTool(slot.item)
