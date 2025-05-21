extends RayCast3D

@onready var player: Player = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_colliding():
		pass

func handlePlace() -> void:
	var item: Item = player.hotbar.activeSlot.item
	if item is PlaceObject:
		item.placeObject()
		player.hotbar.decreaseCurrentSlot(1)

func handleInput(event: InputEvent) -> void:
	if not is_colliding():
		return
	
	var target: Node = get_collider()
	var collection: Dictionary = findTargetType(target)
	
	if not collection:
		return
	
	print(collection)
	
	var type: String = collection.keys()[0]
	target = collection[type]
	
	if event.is_action_pressed("attack"):
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
	

#FIXME: Check what type look is currently colliding with (Minable etc.)

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
