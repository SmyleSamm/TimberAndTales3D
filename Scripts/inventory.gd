extends Control

@export var columns: int
@export var depth: int

@onready var gc: GridContainer = $ScrollContainer/GridContainer

var slots: Array = []
var items: Array = []

func _ready() -> void:
	checkHSize()
	gc.columns = columns
	init()
	#hide()
	fillInv()

func checkHSize() -> void:
	# TODO: Check via size of button and container how many can fit in it
	if columns > 4:
		printerr("There are to many columns! Max size is 4")
		print("Resizing is necesarry!")
	else:
		return
	var temp: int = columns
	var removed: int = 0
	while temp > 4:
		temp -= 1
		removed += 1
	var extraDepth: int = int(int(removed/4)*depth)
	columns -= removed
	depth += extraDepth

func init() -> void:
	for i in range(depth):
		var columSlots: Array = []
		for x in range(columns):
			var slot: Slot = Slot.new()
			var tool: Tool = preload("res://Resources/Tools/hand.tres")
			slot.item = tool
			slot.updateLabel()
			gc.add_child(slot)
			columSlots.append(slot)
		slots.append(columSlots)

#TODO: Check if inventory is big enough (out of bounds)
func addItem(item: Item, slotID: int) -> void:
	if slotID != -1:
		if checkIfSlotIsEmpty(slotID):
			setItem(slotID, item)
		else:
			printerr("Slot is already filled!")
	else:
		pass
	pass

func setItem(slotID: int, item: Item) -> void:
	var slotCoords: Array[int] = getSlotCoords(slotID)
	var slot: Slot = slots[slotCoords[0] - 1][slotCoords[1] - 1]
	slot.item = item
	slot.icon = item.icon

func checkIfSlotIsEmpty(slotID: int) -> bool:
	var slotCoords: Array[int] = getSlotCoords(slotID)
	print(slotCoords)
	var item: Item = getItemInSlot(slotCoords[0], slotCoords[1])
	return item.name == "Hand"

func getItemInSlot(row: int, height: int) -> Item:
	var slot: Slot = getSlotRaw(row, height)
	return slot.item

func getSlot(slotID: int) -> Slot:
	var slotCoords: Array[int] = getSlotCoords(slotID)
	var slot: Slot = slots[slotCoords[0] - 1][slotCoords[1] - 1]
	return slot

func getSlotRaw(row: int, height: int) -> Slot:
	var slot: Slot = slots[row-1][height-1]
	return slot

func getSlotCoords(slotID: int) -> Array[int]:
	var coords: Array[int] = []
	var height: int = getHeightOfSlot(slotID)
	var row: int = getRowOfSlot(slotID, height)
	coords.append(height)
	coords.append(row)
	return coords

func getHeightOfSlot(slotID: int) -> int:
	var rawVal: float = float(slotID)/float(columns)
	var intVal: int = int(rawVal)
	
	if rawVal == intVal:
		return intVal
	else:
		return intVal + 1

func getRowOfSlot(slotID: int, slotHeight: int) -> int:
	var slotsRemoved: int = slotHeight * columns
	var row: int = slotID - slotsRemoved + columns
	return row

func updateInventory() -> void:
	pass

#FIXME: Slot only has a icon, thus nothing is displayed

func updateSlot(slotID: int) -> void:
	var slot: Slot = getSlot(slotID)
	print(slot.item.stackSize)
	slot.updateLabel()
	pass


func fillInv() -> void:
	for i in range(1, 10):
		print("Filling inv on index: ",i)
		var item: Item = load("res://Resources/ItemData/wood.tres")
		item.stackSize = randi_range(0, 999)
		addItem(item, i)
		updateSlot(i)
	for i in range(10, 17):
		print("Filling inv on index: ",i)
		var item: Item = load("res://Resources/ItemData/wood.tres")
		addItem(item, i)
	pass
