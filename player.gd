class_name Player extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.001
const RUNNING = 0.5
const ATTACKDAMAGE = 10
@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var look: RayCast3D = $Head/RayCast3D

var isUIOpen: bool = false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event: InputEvent) -> void:
	handleMouseInputs(event)
	handleKeyInputs(event)
	
func handleMouseInputs(event: InputEvent) -> void:
	if isUIOpen:
		return
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, -1, 1)
		look.rotation.x = camera.rotation.x
		look.rotation.y = camera.rotation.y
		
func handleKeyInputs(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		attack()
	if event.is_action_pressed("interact"):
		interact()
	if event.is_action_pressed("ESC"):
		quit()

func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
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
	
	var target = look.get_collider().get_parent()
	if target is Minable:
		var attack: Attack = Attack.new()
		attack.base_damage = 10
		attack.base_lvl = 1
		target.hit(attack)

func interact() -> void:
	if not look.is_colliding():
		return
	
	var target = look.get_collider()
	
	if target is Crafting:
		var ui: Control = target.getUI()
		if not ui:
			printerr("The target has no UI defined!")
			return
		if isUIOpen:
			closeUI(ui)
		else:
			openUI(ui)
		#create new CanvasLayer
		#set the crafting things
		#display it
		#disable movement
		pass
	if target is Repairable:
		target.interact()
		
func openUI(ui: Control) -> void:
	isUIOpen = true
	World.hideAllUI()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	ui.show()
	
func closeUI(ui: Control) -> void: 
	isUIOpen = false
	World.showAllUI()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	ui.hide()
