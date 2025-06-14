class_name Animal extends CharacterBody3D


@export var area: Area3D

@export_group("Movement")

@export var canWalk: bool
@export var canFly: bool
@export var canJump: bool
@export_range(0, 10, 0.2) var jumpHeight: float

@export_subgroup("Speed")
@export_range(0, 100.0, 1.0) var slowSpeed: float
@export_range(0, 100.0, 1.0) var mediumSpeed: float
@export_range(0, 100.0, 1.0) var fastSpeed: float

@export_group("Attributes")

@export_subgroup("Food")
@export var needsFood: bool
@export_range(0, 100, 1) var stomachSize: int
@export var needsWater: bool
@export_range(0, 100, 1) var bladerSize: int

@export_group("Run From Player")
@export var runFromPlayer: bool
@export_range(0, 20.0, 0.5) var detectionRadius: float
@export_range(0, 10.0, 0.5) var lowerBoundRunAwayTimer: float
@export_range(0, 10.0, 0.5) var upperBoundRunAwayTimer: float

var detectionArea: Area3D
var isPlayerInRange: bool = false

var isRunningAway: bool = false
var isRunningAwayTimer: float = 0.0
var runAwayTimerCap: float = 0.0
var runAwayDirection: Vector3

func _ready() -> void:
	if detectionRadius > 0:
		detectionArea = World.createScan(self, detectionRadius)
		detectionArea.connect("body_entered", Callable(self, "playerEnteredDetectionArea"))
		detectionArea.connect("body_exited", Callable(self, "playerLeftDetectionArea"))

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if not isRunningAway:
		velocity.x = 0
		velocity.z = 0
	
	move_and_slide()

func _process(delta: float) -> void:
	#TODO: Run into oppisite direction from player
	
	if isRunningAway:
		
		goInDirection(runAwayDirection, delta, slowSpeed)
		isRunningAwayTimer += delta
		
		#Stops running away after a random time
		#This time is calculated in "runAwayFromPlayer" via 
		#lower and upperBoundRunAwayTimer
		
		if isRunningAwayTimer >= runAwayTimerCap:
			isRunningAway = false

func getRunAwayDirection(player: Player) -> Vector3:
	var direction: Vector3 = position - player.position
	direction = direction * Vector3(1,0,1)
	return direction.normalized()

func playerEnteredDetectionArea(body) -> void:
	if not body is Player:
		return
	isPlayerInRange = true
	if runFromPlayer:
		runAwayFromPlayer(body)

func playerLeftDetectionArea(body) -> void:
	if not body is Player:
		return 
	isPlayerInRange = false

func runAwayFromPlayer(body: Player) -> void:
	isRunningAway = true
	isRunningAwayTimer = 0.0
	runAwayTimerCap = randf_range(lowerBoundRunAwayTimer, upperBoundRunAwayTimer)
	runAwayDirection = getRunAwayDirection(body)

func goInDirection(vector: Vector3, delta: float, speed: float) -> void:
	if vector:
		velocity.x = vector.x * speed
		velocity.z = vector.z * speed
	else:
		velocity.x = 0
		velocity.z = 0
	
	move_and_slide()
	
