class_name Minable extends StaticBody3D

signal destroyed

var health: int

#TODO: refactor code to fit new export variables

@export_subgroup("Properties")
@export_range(0,1000, 1, "or_greater") var maxHealth: int
@export_range(0,5,0.9) var strenght: int
@export_subgroup("Minable")
@export var requiresTool: bool
@export var resourceType: ToolType
@export var resources: Array[ItemDrops]
@export_subgroup("Respawn")
@export var canRespawn: bool
@export var respawnElement: RespawnElement
@export_range(0,200,0.9, "or_greater") var respawnTime: int

func _ready() -> void:
	health = maxHealth
	
func hit(attack: Attack):
	if _canAttack(attack):
		_attack(attack)
		_changeResources(attack)
	else:
		print("Attack is not strong enough!")
		
func _attack(attack: Attack) -> void:
	if _getRemainderHealth(attack) > 0:
		health -= attack.base_damage
	else:
		noHealth()

func _getRemainderHealth(attack: Attack) -> int:
	return health - attack.base_damage
	
func _canAttack(attack: Attack) -> bool:
	if not checkAttackType(attack):
		return false
	if strenght:
		if attack.base_lvl >= strenght:
			return true
		else:
			return false
	else:
		print("No strength was assigned")
	return true
	
func checkAttackType(attack: Attack) -> bool:
	if resourceType:
		if attack.base_type:
			if resourceType == attack.base_type:
				return true
			else:
				return false
		else:
			print("No attack type assigned!")
			if requiresTool:
				return false
			else:
				return true
	else:
		print("No resource type assigned!")
		return true
		
func _changeResources(attack: Attack) -> void:
	for i in resources:
		if not i.count:
			i.count = i.maxCount
		var expected_count = round(i.maxCount * float(health) / float(maxHealth))
		var reduction = i.count - expected_count
		World.changeResources(i.item, reduction)
		i.count = expected_count
		
func get_resources() -> Array[Item]:
	var items: Array[Item] = []
	for i in resources:
		items.append(i.item)
	return items

func add_resources(items: Array[ItemDrops]) -> void:
	for i in items:
		resources.append(i)

func noHealth() -> void:
	health = 0
	destroyed.emit()
	queue_free()
