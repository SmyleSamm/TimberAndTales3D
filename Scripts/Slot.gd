class_name Slot extends Button

@export var item: Item

@onready var counter: Label
var slotSize: int = 0

var heldDown: bool = false
var holdingTexture: TextureRect
var startCords: Vector2

signal slot_hovered(slot: Slot)
signal slot_dropped(slot: Slot)
var inventory: Inventory


#TODO: Items in slots can be moved

func _ready() -> void:
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)
	
	if item:
		icon = item.icon
		updateLabel()

func getAttack() -> Attack:
	if item is Tool:
		return item.attack
	var attack: Attack = Attack.new()
	attack.base_damage = 10
	attack.base_lvl = 1
	return attack

func updateLabel() -> void:
	var labelText: String = str(slotSize)
	if not counter:
		counter = getCounterLabel()
		add_child(counter)
	
	if slotSize > 1:
		counter.show()
		counter.text = labelText
	elif slotSize <= 0:
		var tool: Tool = preload("res://Resources/Tools/hand.tres")
		item = tool
		icon = item.icon
		counter.hide()
	else:
		counter.hide()

func changeSlotSize(amount: int) -> void:
	slotSize += amount
	updateLabel()

func getCounterLabel() -> Label:
	var label = Label.new()
	label.theme = load("res://Resources/Fonts/pixelStyle.tres")
	label.scale = Vector2(0.5, 0.5)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	label.set_anchors_preset(Control.PRESET_TOP_LEFT)
	label.custom_minimum_size = Vector2(64, 0)
	label.position = Vector2(0, 24)
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 20)
	label.add_theme_color_override("font_color", Color.WHITE_SMOKE)
	return label


func _process(delta: float) -> void:
	pass
	if heldDown:
		holdingTexture.position = get_viewport().get_mouse_position() - startCords

func connectSignalsAfterInit(inv: Inventory) -> void:
	self.inventory = inv
	connect("slot_dropped", inventory._on_slot_dropped)

func _on_button_down() -> void:
	if item and inventory:
		holdingTexture = TextureRect.new()
		holdingTexture.texture = icon
		#holdingTexture.top_level = true
		holdingTexture.z_index = 100
		add_child(holdingTexture)
		hideSlot()
		heldDown = true
		startCords = position + 2* size - size / 4
		inventory.start_drag(item, self)
	else:
		printerr("No Item or inventory")

func _on_button_up() -> void:
	heldDown = false
	holdingTexture.queue_free()
	if inventory:
		inventory.stop_drag()
	else:
		printerr("No inventory")

func hideSlot() -> void:
	counter.text = ""
	icon = load("res://Resources/Tools/hand.tres").icon

func changeCurrentSlot(slot: Slot) -> void:
	#print("Changing slot from ", currentSlot, " to ",slot.name)
	self.currentSlot = slot
	print(self.name, "is recieving!")
