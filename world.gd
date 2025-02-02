extends Node3D

@export var counter: CanvasLayer

func get_current_world() -> Node3D:
	return get_tree().root.get_child(2)

func get_current_counter() -> CanvasLayer:
	for i in get_current_world().get_children():
		if i.name == "Counter":
			return i
	printerr("Counter Node was not found!")
	return null

func changeResources(resource: Item, value: int) -> void:
	get_current_counter().changeResources(resource, value)

func getResources():
	return get_current_counter().resources

func get_current_debug() -> CanvasLayer:
	for i in get_current_world().get_children():
		if i.name == "Debug":
			return i
	printerr("Debug Node was not found!")
	return null

func hideAllUI() -> void:
	get_current_debug().hide()
	get_current_counter().hide()

func showAllUI() -> void:
	get_current_debug().show()
	get_current_counter().show()
