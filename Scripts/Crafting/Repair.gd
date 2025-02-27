class_name Repairable extends StaticBody3D

@export var resources: Array[ItemDrops]
@export var repair: PackedScene

func interact() -> void:
	if _canRepair():
		spawnRepair()
		queue_free()
		_reduceResources()

func _reduceResources() -> void:
	for i in resources:
		World.changePlayerResource(i.item, -i.maxCount)

func spawnRepair() -> void:
	var instance = repair.instantiate()
	instance.position = position 
	get_parent().add_child(instance)

#FIXME: Potentially only works for single stack operations 
#(if e.g. 1000 wood is need but player only has 999(full Stack) 
#-> returns maybe true)

func _canRepair() -> bool:
	for i in resources:
		if not World.checkIfPlayerHasEnoughItems(i.item, i.maxCount):
			return false
	return true
