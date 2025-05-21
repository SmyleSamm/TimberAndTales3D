extends RayCast3D

@onready var player: Player = $"../.."

var closeToObject: bool
var objectsInRange: Array[Node]
var tipp: Label

func _process(delta: float) -> void:
	if not closeToObject:
		return
	
	handleInput(null)

func showText(target: Node, type: String) -> void:
	
	if tipp:
		return
	
	var canvas: CanvasLayer = World.get_current_debug()
	
	var label: Label = Label.new()
	var text: String = "Press 'E' to "
	
	if type == "Repairable":
		text += "repair!\nYou need:"+target.getResourceText()
	else:
		text += "interact"
	
	label.text = text
	label.add_theme_color_override("font_color", Color(0.0, 1.0, 0.0))
	
	var width: int = get_viewport().get_visible_rect().size.x
	var height: int = get_viewport().get_visible_rect().size.y
	#var offset: Vector2 = Vector2(0, 50)
	
	var position: Vector2 = Vector2(width / 2, height / 2) #+ offset
	
	label.position = position
	
	tipp = label
	
	canvas.add_child(label)

func inRange(obj: Node) -> void:
	objectsInRange.append(obj)
	closeToObject = true

func tooFaar(obj: Node) -> void:
	if not removeObject(obj):
		printerr("Removal of close Object in PlayerLook.gd failed!")
	if len(objectsInRange) < 1:
		closeToObject = false
		if tipp:
			tipp.queue_free()
			tipp = null

func removeObject(obj: Node) -> bool:
	for i in range(len(objectsInRange)):
		var object: Node = objectsInRange[i]
		if object == obj:
			objectsInRange.remove_at(i)
			return true
	return false

func handlePlace() -> void:
	var item: Item = player.hotbar.activeSlot.item
	if item is PlaceObject:
		item.placeObject()
		player.hotbar.decreaseCurrentSlot(1)

func handleInput(event: InputEvent) -> void:
	if not is_colliding():
		if tipp:
			tipp.queue_free()
			tipp = null
		return
	
	var target: Node = get_collider()
	var collection: Dictionary = findTargetType(target)
	
	if not collection:
		return
	
	var type: String = collection.keys()[0]
	target = collection[type]
	
	if not event:
		showText(target, type)
	elif event.is_action_pressed("attack"):
		handleAttack(target, type)
	elif event.is_action_pressed("interact"):
		handleInteraction(target, type)

func handleInteraction(target: Node, type: String) -> void:
	if type == "Repairable":
		target.interact()
	
	if type == "NPC":
		target.talkToPlayer()
	
	if type == "Crafting":
		var ui: Control = target.getUI()
		if not ui:
			printerr("The target has no UI defined!")
			return
		player.openUI(ui)

func handleAttack(target: Node, type: String) -> void:
	if type == "Minable":
		target.registerInteraction(player.hotbar.getAttack(), player.inventory)

func findTargetType(target: Node) -> Dictionary:
	var current: Node = target
	while current:
		var type: String = checkClass(current)
		if type:
			return {type: current}
		current = current.get_parent()
	return {}

func checkClass(target: Node) -> String:
	if target is Minable:
		return "Minable"
	
	if target is Repairable:
		return "Repairable"
	
	if target is Crafting:
		return "Crafting"
	
	if target is NPC:
		return "NPC"
	
	return ""
