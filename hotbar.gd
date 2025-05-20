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
	
	if activeSlot and activeSlot.item is PlaceObject:
		activeSlot.item.hideObject()
	
	var slot: Slot = getSlot(slotID)
	activeSlotID = slotID
	activeSlot = slot
	#TODO: if grab_focus -> jump(space) will function as a click -> might cause problems
	slot.grab_focus()
	item.switchTool(slot.item)
	hand.switchTool(slot.item)
	if slot.item is PlaceObject:
		slot.item.holding()

const TARGET_FPS: int = 30
const INTERVAL: float = 1.0 / TARGET_FPS

var time_passed: float = 0.0

func _process(delta: float) -> void:
	if not activeSlot.item is PlaceObject:
		return
	
	#Normal FPS
	activeSlot.item.showObject()
	
	#30FPS
	#time_passed += delta
	#if time_passed >= INTERVAL:
		#time_passed -= INTERVAL
		#activeSlot.item.showObject()

func decreaseCurrentSlot(amount: int) -> void:
	if activeSlot.slotSize - amount >= 0:
		activeSlot.changeSlotSize(-amount)
