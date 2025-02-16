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
		World.changePlayerResource(i.item, -i.maxCount)

#FIXME: Potentially only works for single stack operations 
#(if e.g. 1000 wood is need but player only has 999(full Stack) 
#-> returns maybe true)

func _canRepair() -> bool:
	for i in resources:
		if not World.checkIfPlayerHasEnoughItems(i.item, i.maxCount):
			return false
	return true
