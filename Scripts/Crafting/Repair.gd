class_name Repairable extends StaticBody3D

@export_category("Basic Repairable")
@export var resources: Array[ItemDrops]
@export var repair: PackedScene
@export_category("PopupLabel")
@export var labelOffset: Vector3
@export var labelRotation: Vector3

var currentPopupLabel: PopupLabel

func _ready() -> void:
	createScan()

func createScan() -> void:
	var scan: Area3D = Area3D.new()
	
	var cs: CollisionShape3D = CollisionShape3D.new()
	var ss: SphereShape3D = SphereShape3D.new()
	ss.radius = 4.0
	
	cs.shape = ss
	
	scan.add_child(cs)
	
	scan.connect("body_entered", Callable(self, "_on_scan_body_entered"))
	scan.connect("body_exited", Callable(self, "_on_scan_body_exited"))
	
	add_child(scan)
	
	scan.global_transform.origin = position

func openPopupLabel(text: String) -> void:
	closePopupLabel()
	var pl: PopupLabel = PopupLabel.new()
	pl.setUp(self, text, labelOffset, labelRotation)
	pl.play_scale_animation()
	currentPopupLabel = pl

func closePopupLabel() -> void:
	if currentPopupLabel:
		currentPopupLabel.queue_free()
		currentPopupLabel = null

func _on_scan_body_entered(body) -> void:
	var text = "Press 'E' to\ninteract"
	openPopupLabel(text)

func _on_scan_body_exited(body) -> void:
	closePopupLabel()

func interact() -> void:
	print("Interacting")
	if _canRepair():
		print("Can be repaired")
		spawnRepair()
		queue_free()
		_reduceResources()
	else:
		var text = "You need:"+getResourceText()
		openPopupLabel(text)

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
