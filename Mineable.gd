class_name Minable extends StaticBody3D

signal destroyed

var health: int
@export var maxHealth: int
@export var strenght: int
@export var resources: Array[ItemDrops]

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
	if strenght:
		if attack.base_lvl >= strenght:
			return true
		else:
			return false
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
