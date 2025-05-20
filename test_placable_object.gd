class_name PlaceObject extends Item

@export_group("PlaceObjects")
@export var canBePlaced: bool = true
@export var object: PackedScene

var isHolding: bool = false
var obj: StaticBody3D
var ray: RayCast3D
var currentWorld: Node3D
var player: Player

func calculatePosition() -> Vector3:
	var ofset: Vector3 = ray.target_position
	var rot: Vector3 = player.head.global_transform.basis * ofset #player.head.global_transform.basis * ofset
	return player.global_transform.origin + rot
	#return player.position + ray.target_position

func test() -> void:
	if not isHolding:
		return
	
	print("Holding")
	
	player = World.getCurrentPlayer()
	
	if not player:
		print("No player")
		return
	
	ray = player.look
	
	if not ray:
		print("No ray")
		return
	
	currentWorld = World.get_current_world()
	
	if not currentWorld:
		print("No world")
		return
	
	#var position: Vector3 = player.position + ray.target_position
	#print(ray.position, ray.target_position, position)
	
	if not object:
		print("No object")
		return
	
	obj = object.instantiate()
	
	if not obj:
		print("No obj")
		return
	
	obj.position = calculatePosition()
	currentWorld.add_child(obj)

func holding() -> void:
	isHolding = true
	test()

func showObject() -> void:
	if not isHolding:
		print("Can't hold")
		return
	obj.position = calculatePosition()

func hideObject() -> void:
	isHolding = false
	obj.queue_free()
