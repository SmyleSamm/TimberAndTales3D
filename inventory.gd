extends Control

@export var columns: int
@export var depth: int

@onready var gc: GridContainer = $ScrollContainer/GridContainer

var slots: Array = []

func _ready() -> void:
	checkHSize()
	gc.columns = columns
	init()
	slotsD()
	hide()
	
	
func checkHSize() -> void:
	# TODO: Check via size how many can fit in it 
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
			var tool: Tool = preload("res://CraftingSystem/Items/Tools/hand.tres")
			slot.item = tool
			gc.add_child(slot)
			columSlots.append(slot)
		slots.append(columSlots)

func slotsD() -> void:
	print(slots)
