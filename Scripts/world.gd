extends Node3D

func get_current_world() -> Node3D:
	return get_tree().root.get_child(1)

func get_current_debug() -> CanvasLayer:
	for i in get_current_world().get_children():
		if i.name == "Debug":
			return i
	printerr("Debug Node was not found!")
	return null

func hideAllUI() -> void:
	get_current_debug().hide()

func showAllUI() -> void:
	get_current_debug().show()


func checkIfPlayerHasEnoughItems(item: Item, count: int) -> bool:
	var hasEnough: bool = false
	var items: Array[Array] = getPlayerResources()
	for i in items:
		var playerItem: Item = i[0]
		var playerCount: int = i[1]
		if playerItem == item:
			if playerCount >= count:
				hasEnough = true
	if not hasEnough:
		return false
	return true

func changePlayerResource(item: Item, count: int) -> void:
	var inventory: Inventory = getCurrentInventory()
	inventory.smartAddItem(item, count)

func getPlayerResources() -> Array[Array]:
	var inventory: Inventory = getCurrentInventory()
	var items: Array[Array] = []
	var inventorySlots: int = inventory.columns * inventory.depth
	for i in range(inventorySlots):
		var item: Item = inventory.getItemInSlot(i+1)
		if item:
			var count: int = inventory.getItemCountInSlot(i+1)
			items.append([item, count])
	return items

func getCurrentInventory() -> Inventory:
	var player: Player = getCurrentPlayer()
	if player:
		return player.inventory
	return

func getCurrentPlayer() -> Player:
	for i in get_current_world().get_children():
		if i.name == "Player":
			return i
	return
