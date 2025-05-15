class_name Inventory extends Control

@export var columns: int
@export var depth: int

@export var maxColumns: int

@onready var gc: GridContainer = $ScrollContainer/GridContainer

var slots: Array = []
var items: Array = []


var draggedItem: Item
var originalSlot: Slot
var hoveredSlot: Slot
#const slotsCount: int = _getTotalSlotCount()

func _ready() -> void:
	checkHSize()
	gc.columns = columns
	init()
	hide()
	#fillInv()

func checkHSize() -> void:
	if columns > maxColumns:
		printerr("There are to many columns! Max size is ",maxColumns)
		print("Resizing is necesarry!")
	else:
		return
	var temp: int = columns
	var removed: int = 0
	while temp > maxColumns:
		temp -= 1
		removed += 1
	var extraDepth: int = int(int(removed/maxColumns)*depth)
	columns -= removed
	depth += extraDepth

func init() -> void:
	for i in range(depth):
		var columSlots: Array = []
		for x in range(columns):
			var slot: Slot = Slot.new()
			var tool: Tool = preload("res://Resources/Tools/hand.tres")
			slot.item = tool
			slot.connectSignalsAfterInit(self)
			slot.updateLabel()
			gc.add_child(slot)
			slot.add_to_group("inventorySlots")
			columSlots.append(slot)
		slots.append(columSlots)

#FIXME: Check if inventory is full or not (Out of bounds error!)
#FIXME: Remove item if count <= 0
func smartAddItem(item: Item, stackSize: int) -> void:
	var check: int = smartInventoryItemInsert(item, stackSize)
	if check == -1:
		var emptySlot: int = getEmptySlot()
		#print(emptySlot)
		setItem(emptySlot, item)
		smartAddItem(item, stackSize)
		updateSlot(emptySlot)
	elif check != 0:
		smartAddItem(item, check)

func smartInventoryItemInsert(item: Item, stackSize: int) -> int:
	var currentStackSize: int = stackSize
	for i in slots:
		for n in i:
			if n.item == item:
				if n.slotSize < n.item.maxStackSize:
					if n.slotSize + currentStackSize <= n.item.maxStackSize:
						n.changeSlotSize(currentStackSize)
						return 0
					else:
						var remainder: int = n.item.maxStackSize - n.slotSize
						currentStackSize -= remainder
						n.changeSlotSize(remainder)
						var check: int = smartInventoryItemInsert(item, currentStackSize)
						if check == -1:
							var emptySlot: int = getEmptySlot()
							setItem(emptySlot, item)
							smartAddItem(item, currentStackSize)
							updateSlot(emptySlot)
						return 0
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

func setStack(slotID: int, item: Item, stackSize: int) -> void:
	var slotCoords: Array[int] = getSlotCoords(slotID)
	var slot: Slot = slots[slotCoords[0] - 1][slotCoords[1] - 1]
	slot.item = item
	slot.icon = item.icon
	slot.slotSize = stackSize
	updateSlot(slotID)

func checkIfSlotIsEmpty(slotID: int) -> bool:
	var slotCoords: Array[int] = getSlotCoords(slotID)
	var item: Item = getItemInSlotRaw(slotCoords[0], slotCoords[1])
	if item:
		return item.name == "Hand"
	return true

func getItemCountInSlot(slotID: int) -> int:
	var slot: Slot = getSlot(slotID)
	if slot.item.name != "Hand":
		return slot.slotSize
	return 0

func getItemInSlot(slotID: int) -> Item:
	var slot: Slot = getSlot(slotID)
	if slot.item.name != "Hand":
		return slot.item
	else:
		return 

func getItemInSlotRaw(row: int, height: int) -> Item:
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
	var item: Item = load("res://Resources/ItemData/wood.tres")
	var item1: Item = load("res://Resources/ItemData/stone.tres")
	smartAddItem(item, 1999)
	smartAddItem(item1, 2999)
	smartAddItem(item, 2000)

#func fillInv() -> void:
	#for i in range(1, 10):
		#var item: Item = load("res://Resources/ItemData/wood.tres")
		#var stackSize = randi_range(0, 999)
		##addItem(item, stackSize)
		#smartAddItem(item, stackSize)
	#for i in range(10, 17):
		#var item: Item = load("res://Resources/ItemData/stone.tres")
		##addItem(item, 1)
		#var stackSize = randi_range(0, 999)
		#smartAddItem(item, stackSize)
	#for i in range(1, 10):
		#var item: Item = load("res://Resources/ItemData/wood.tres")
		#var stackSize = randi_range(0, 999)
		##addItem(item, 1)
		#smartAddItem(item, stackSize)
		#updateSlot(i)
	#pass


func _process(delta: float) -> void:
	if draggedItem:
		var mousePos = get_viewport().get_mouse_position()
		var newSlot = getSlotAtPosition(mousePos)
		if newSlot:
			hoveredSlot = newSlot
			
func getSlotAtPosition(pos: Vector2) -> Slot:
	for slot in get_tree().get_nodes_in_group("inventorySlots"):
		if slot.get_global_rect().has_point(pos):
			return slot
	return


func start_drag(item: Item, slot: Slot) -> void:
	draggedItem = item
	originalSlot = slot
	slot.item = null

func stop_drag() -> void:
	#print("Dropped on: ", hoveredSlot.name)
	#print(hoveredSlot.item)
	if hoveredSlot and hoveredSlot != originalSlot:
		var item: Item = hoveredSlot.item
		var itemIcon: Texture2D = hoveredSlot.icon
		var slotSize: int  = hoveredSlot.slotSize
		
		hoveredSlot.item = draggedItem
		hoveredSlot.icon = draggedItem.icon
		hoveredSlot.slotSize = originalSlot.slotSize
		
		originalSlot.item = item
		originalSlot.icon = itemIcon
		originalSlot.slotSize = slotSize
	else:
		originalSlot.item = draggedItem
		originalSlot.icon = draggedItem.icon
	
	draggedItem = null
	originalSlot = null
	updateInventory()
	print(checkIfTool(-1, hoveredSlot))
	
func _on_slot_hovered(slot: Slot) -> void:
	print(slot.name)
	hoveredSlot = slot

func _on_slot_dropped(slot: Slot) -> void:
	print("Item dropped on slot: ",slot.name)

func _free_item_ui() -> void:
	for i in slots:
		for n in i:
			if n.currentItemUI:
				n.currentItemUI.queue_free()
				n.currentItemUI = null

func _equip_item(slot: Slot) -> void:
	print(slot)

func checkIfTool(slotID: int, s: Slot) -> bool:
	var slot: Slot
	if slotID == -1:
		slot = s
	else:
		slot = getSlot(slotID)
	
	if slot:
		if slot.item is Item:
			return slot.item is Tool
	return false
