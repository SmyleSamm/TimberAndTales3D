class_name Repairable extends StaticBody3D

signal repaired
@export var resources: Array[ItemDrops]

func interact() -> void:
	if _canRepair():
		repaired.emit()
		_reduceResources()
	pass

func _reduceResources() -> void:
	for i in resources:
		World.changeResources(i.item, -i.maxCount)

func _canRepair() -> bool:
	var canCraft: bool = true
	var items: Array[Item] = World.getResources()
	for i in resources:
		var resource: Item = i.item
		if resource in items:
			for n in items:
				if resource == n:
					if i.maxCount > n.stackSize:
						return false
		else:
			return false
	return canCraft
