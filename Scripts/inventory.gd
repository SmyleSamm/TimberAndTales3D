extends Control

@export var columns: int
@export var depth: int

@onready var gc: GridContainer = $ScrollContainer/GridContainer

var slots: Array = []
var items: Array = []

#const slotsCount: int = _getTotalSlotCount()

func _ready() -> void:
	checkHSize()
	gc.columns = columns
	init()
	hide()
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
func addItem(item: Item, stackSize: int) -> void:
	var check: int = checkIfItemInInventory(item)
	if check == -1:
		var emptySlot: int = getEmptySlot()
		setItem(emptySlot, item)
		check = emptySlot
	var slot: Slot = getSlot(check)
	slot.changeSlotSize(stackSize)

func checkIfItemInInventory(item: Item) -> int: #-1 = not in inv
	var slotID: int = 1
	for i in slots:
		for n in i:
			if n.item == item:
				return slotID
			slotID += 1
	return -1

func getEmptySlot() -> int: #-1 = no empty slot
	var slotsCount: int = columns * depth
	for i in range(slotsCount):
		i += 1
		if checkIfSlotIsEmpty(i):
			return i
	return -1
	
func setItem(slotID: int, item: Item) -> void:
	var slotCoords: Array[int] = getSlotCoords(slotID)
	var slot: Slot = slots[slotCoords[0] - 1][slotCoords[1] - 1]
	slot.item = item
	slot.icon = item.icon

func checkIfSlotIsEmpty(slotID: int) -> bool:
	var slotCoords: Array[int] = getSlotCoords(slotID)
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
	var len: int = columns * depth
	for i in range(len):
		updateSlot(i+1)
	pass

func updateSlot(slotID: int) -> void:
	var slot: Slot = getSlot(slotID)
	slot.updateLabel()

func fillInv() -> void:
	for i in range(1, 10):
		var item: Item = load("res://Resources/ItemData/wood.tres")
		#var stackSize = randi_range(0, 999)
		addItem(item, 1)
		updateSlot(i)
	for i in range(10, 17):
		var item: Item = load("res://Resources/ItemData/stone.tres")
		addItem(item, 1)
	for i in range(1, 10):
		var item: Item = load("res://Resources/ItemData/wood.tres")
		#var stackSize = randi_range(0, 999)
		addItem(item, 1)
		updateSlot(i)
	pass
