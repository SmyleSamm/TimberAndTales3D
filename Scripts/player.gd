class_name Player extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.001
const RUNNING = 0.5
const ATTACKDAMAGE = 10
@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var look: RayCast3D = $Head/RayCast3D
@onready var inventory: Control = $UI/Inventory
@onready var hotbar: Hotbar = $UI/Hotbar
@onready var hand: Node3D = $Head/Hand

var isUIOpen: bool = false
var currentUI: Control
var dialogue: bool = false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hotbar.visible = true
	#hotbar debug tools
	#var pickaxe: Tool = load("res://Resources/Tools/pickaxe_stone.tres")
	#var axe: Tool = load("res://Resources/Tools/axe_stone.tres")
	#hotbar.smartAddItem(pickaxe, 1)
	#hotbar.smartAddItem(axe, 1)
	hotbar.activateSlot(1)
	
func _input(event: InputEvent) -> void:
	if isUIOpen or dialogue:
		handleUIINputs(event)
		return
	
	handleMouseInputs(event)
	handleKeyInputs(event)
	
func handleMouseInputs(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, -1, 1)
		look.rotation.x = camera.rotation.x
		look.rotation.y = camera.rotation.y

func handleUIINputs(event: InputEvent) -> void:
	if isUIOpen:
		if event.is_action_pressed("closeUI"):
			closeUI(currentUI)
		if currentUI == inventory:
			if event.is_action_pressed("inventory"):
				closeUI(currentUI)
		return

func handleKeyInputs(event: InputEvent) -> void:
	if event.is_action_pressed("ESC"):
		quit()
		
	if event.is_action_pressed("interact"):
		interact()
	
	if event.is_action_pressed("attack"):
		attack()
	
	if event.is_action_pressed("save"):
		SaveGame.saveGame()
	
	if event.is_action_pressed("load"):
		SaveGame.loadGame()
	
	if event.is_action_pressed("delete"):
		SaveGame.deleteGameFile()
	
	if event.is_action_pressed("inventory"):
		inventory.updateInventory()
		openUI(inventory)
	handleHotbar(event)

func handleHotbar(event: InputEvent) -> void:
	if isUIOpen or dialogue:
		return
	
	if event.is_action_pressed("slot"):
		var slotID: int = event.keycode - KEY_0
		hotbar.activateSlot(slotID)
	
	if event.is_action("switchSlot") and event.is_pressed():
		var up: bool = bool(event.button_index - MOUSE_BUTTON_WHEEL_DOWN)
		var nextSlotID: int = int(up) * 2 - 1
		var nextSlot: int = hotbar.activeSlotID + nextSlotID
		
		if nextSlot <= 0:
			nextSlot = hotbar.columns
		elif nextSlot > hotbar.columns:
			nextSlot = 1
			
		hotbar.activateSlot(nextSlot)

func _physics_process(delta: float) -> void:
	#Disables Physiks when UI is open
	if isUIOpen or dialogue:
		return
	
	#Add running
	var run: float = int(Input.is_action_pressed("move_fast")) * RUNNING
	run = 1 + run

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction: Vector3 = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized() * run
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = 0
		velocity.z = 0

	move_and_slide()

func quit() -> void:
	get_tree().quit()

func attack() -> void:	
	if not look.is_colliding():
		return
	
	var target = look.get_collider()
	
	if target is not Minable:
		target = target.get_parent()
	if target is not Minable:
		target = target.get_parent()
	if target is not Minable:
		target = target.get_parent()
	if target is Minable:
		target.registerInteraction(hotbar.getAttack(), inventory)

func interact() -> void:
	if not look.is_colliding():
		return
	
	var target = look.get_collider()
	
	if target is not Crafting and target is not Repairable and target is not NPC:
		target = target.get_parent()
	if target is not Crafting and target is not Repairable and target is not NPC:
		target = target.get_parent()
	if target is Crafting:
		var ui: Control = target.getUI()
		if not ui:
			printerr("The target has no UI defined!")
			return
		openUI(ui)
		
	if target is Repairable:
		target.interact()
	
	if target is NPC:
		target.talkToPlayer()

func openUI(ui: Control) -> void:
	isUIOpen = true
	currentUI = ui
	World.hideAllUI()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	ui.show()
	
func closeUI(ui: Control) -> void: 
	isUIOpen = false
	World.showAllUI()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	ui.hide()

func setDialogue(state: bool) -> void:
	dialogue = state
	if state:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
