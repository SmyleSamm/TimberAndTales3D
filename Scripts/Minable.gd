class_name Minable extends StaticBody3D

signal destroyed

@export_subgroup("Properties")
@export_range(0,1000, 1, "or_greater") var maxHealth: int
@export_range(0,5,0.9) var strength: int
@export_subgroup("Minable")
@export var requiresTool: bool
@export var resourceType: ToolType
@export var resources: Array[ItemDrops]
@export_subgroup("Respawn")
@export var canRespawn: bool
@export var respawnElement: RespawnMinableElement
@export var normalElement: NormalMinableElement
@export_range(0,200,0.9, "or_greater") var respawnTime: int

var health: int
var inventory: Inventory
var attack: Attack
var resourceCounts: Array[int] = []
var isRespawning: bool

func _ready() -> void:
	hideRespawnObject()

func registerInteraction(atk: Attack, inv: Inventory) -> void:
	attack = atk
	inventory = inv
	hit()


func hit() -> void:
	if checkToolRequirements():
		gettingHit()
	pass

func gettingHit() -> void:
	takeDamage()
	dropItems()
	checkHealthRequirements()

func takeDamage() -> void:
	health -= attack.base_damage
	if health <= 0:
		health = 0

func dropItems() -> void:
	for i in len(resources):
		var expected_count: int = round(resources[i].maxCount * float(health) / float(maxHealth))
		var reduction: int = resourceCounts[i] - expected_count
		resourceCounts[i] = expected_count
		inventory.smartAddItem(resources[i].item, reduction)

func initializeResourceCount() -> void:
	if len(resourceCounts) <= 0:
		for i in range(len(resources)):
			resourceCounts.append(resources[i].maxCount)
	else:
		for i in range(len(resources)):
			resourceCounts[i] = resources[i].maxCount

func checkHealthRequirements() -> void:
	if health <= 0 && not isRespawning:
		respawn()

func checkToolRequirements() -> bool:
	return checkStrngthRequirements() and checkBaseTypeRequirements()

func checkStrngthRequirements() -> bool:
	return attack.base_lvl >= strength
		
func checkBaseTypeRequirements() -> bool:
	if requiresTool:
		return checkWithToolRequirement()
	return checkNoToolRequirement()

#FIXME: Check no Tool requirement
func checkNoToolRequirement() -> bool:
	#var hand: ToolType = load("res://Resources/Tools/hand.tres")
	#if attack.base_type == hand:
		#return true
	#return attack.base_type == resourceType
	return true
	
func checkWithToolRequirement() -> bool:
	return attack.base_type == resourceType




func respawn() -> void:
	if not checkRespawnRequirements():
		return
	showRespawnObject()
	spawnRespawnTimer()
	
func checkRespawnRequirements() -> bool:
	if not canRespawn:
		return false
	if not respawnElement:
		printerr("Object is respawnable, but no respawn Element was assigned")
		return false
	return true

func showRespawnObject() -> void:
	isRespawning = true
	if respawnElement:
		respawnElement.show()
	if normalElement:
		normalElement.hide()

func hideRespawnObject() -> void:
	self.health = maxHealth
	initializeResourceCount()
	isRespawning = false
	if respawnElement:
		respawnElement.hide()
	if normalElement:
		normalElement.show()

func spawnRespawnTimer() -> void:
	var timer: Timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = respawnTime
	timer.timeout.connect(_onRespawnTimerTimeout)
	add_child(timer)
	timer.start()
	
func _onRespawnTimerTimeout() -> void:
	hideRespawnObject()
