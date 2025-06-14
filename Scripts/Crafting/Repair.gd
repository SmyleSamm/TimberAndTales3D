class_name Repairable extends StaticBody3D

@export_category("Basic Repairable")
@export var resources: Array[ItemDrops]
@export var repair: PackedScene
@export_category("PopupLabel")
@export var labelOffset: Vector3
@export var labelRotation: Vector3

var currentPopupLabel: PopupLabel

func _ready() -> void:
	var scan: Area3D = World.createScan(self, 0)
	scan.connect("body_entered", Callable(self, "_on_scan_body_entered"))
	scan.connect("body_exited", Callable(self, "_on_scan_body_exited"))

func _on_scan_body_entered(body) -> void:
	body.look.inRange(self)

func _on_scan_body_exited(body) -> void:
	body.look.tooFaar(self)

func interact() -> void:
	print("Interacting")
	if _canRepair():
		print("Can be repaired")
		spawnRepair()
		queue_free()
		_reduceResources()
	else:
		var text = "You need:"+getResourceText()
		#openPopupLabel(text)

func getResourceText() -> String:
	var text: String = ""
	for i in resources:
		var subtext: String = "\n"+str(i.maxCount)+" "+i.item.name
		text += subtext
	return text

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
