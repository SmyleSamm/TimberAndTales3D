class_name SaveGame extends Node

static var save_path = "user://savegame.txt"

static func getInBrakets(text: String) -> Array:
	var regex = RegEx.new()
	regex.compile(r"\((.*?)\)")
	
	var results = []
	for match in regex.search_all(text):
		results.append(match.get_string(1))
	#print("brakets ",results)
	return results

static func getVector3(parts: Array) -> Vector3:
	var x1: float = float(parts[0])
	var x2: float = float(parts[1])
	var x3: float = float(parts[2])
	
	return Vector3(x1, x2, x3)

static func loadGame() -> void:
	print("Loading...")
	
	var lc: bool = true
	
	if not loadInventories():
		lc = false
	
	if not spawnEnteties():
		lc = false
	
	if lc:
		print("Loaded game!")
	else:
		print("Game not loaded correctly!")

static func saveGame() -> void:
	print("Saving game...")
	
	var invDat = getInventoryData(World.getCurrentInventory())
	var barDat = getInventoryData(World.getCurrentPlayer().hotbar)
	var barActiveSlot = World.getCurrentPlayer().hotbar.activeSlotID
	
	var playerPossition = World.getCurrentPlayer().position
	#var playerView = World.getCurrentPlayer().camera.rotation
	var playerView = World.getCurrentPlayer().camera.rotation
	var playerRay = World.getCurrentPlayer().look.rotation
	var playerHand = World.getCurrentPlayer().hand.rotation
	var playerHead = World.getCurrentPlayer().head.rotation
	
	print("Save"+str(playerView))
	var saveData = {
		#Inventory
		"rowsInv": invDat[0],
		"colsInv": invDat[1],
		"slotsInv": invDat[2],
		
		#Hotbar
		"rowsHot": barDat[0],
		"colsHot": barDat[1],
		"slotsHot": barDat[2],
		"activeHot": barActiveSlot,
		
		#Player
		"playerPos": playerPossition,
		"playerView": playerView,
		"playerRay": playerRay,
		"playerHand": playerHand,
		"playerHead": playerHead,
	}
	var jsonInventoryData = JSON.stringify(saveData)
	
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_string(jsonInventoryData)
		file.close()
	
	var inv: Inventory = World.getCurrentInventory()
	
	print("Saved game!")
	
	#loadGame()
	
	pass

static func getInventoryData(inv:Inventory) -> Array:
	var inventoryData: Array
	
	var invArray: Array[Array]
	
	for i in inv.slots:
		var line: Array[String]
		for x in i:
			var itemName = x.item.resource_path
			itemName = itemName.split("/")
			itemName = itemName[len(itemName)-1].split(".")[0]
			line.append(itemName+"."+str(x.slotSize))
		invArray.append(line)
	inventoryData.append(len(inv.slots))
	inventoryData.append(len(inv.slots[0]))
	inventoryData.append(invArray)
	
	return inventoryData

static func spawnEnteties():
	print("loading Enteties")
	loadPlayer()
	
	print("loaded Enteties")
	return true

static func loadPlayer() -> bool:
	print("loading Player")
	
	var save: Dictionary = getSavedData()
	if not save:
		print("Failed to load save!")
		return false
	
	var possitionParts = getInBrakets(save["playerPos"])[0].split(",")
	var viewParts = getInBrakets(save["playerView"])[0].split(",")
	var rayParts = getInBrakets(save["playerRay"])[0].split(",")
	var headParts = getInBrakets(save["playerHead"])[0].split(",")
	
	var currentPlayer: Player = World.getCurrentPlayer()
	if not currentPlayer:
		print("Failed to load Player!")
		return false
	
	currentPlayer.position = getVector3(possitionParts)
	currentPlayer.camera.rotation = getVector3(viewParts)
	currentPlayer.look.rotation = getVector3(rayParts)
	currentPlayer.head.global_rotation = getVector3(headParts)
	
	print("loaded Player")
	return true

static func getSavedData() -> Dictionary:
	print("Getting save data...")
	
	if not FileAccess.file_exists(save_path):
		print("Save file not found!")
		return {}
	
	var file = FileAccess.open(save_path, FileAccess.READ)
	if file:
		print("In file")
		var content = file.get_as_text()
		file.close()
		
		var parsed = JSON.parse_string(content)
		if not parsed:
			print("Failed to parse JSON!")
			return {}
		print("Send save data!")
		return parsed
	print("No file!")
	return {}

static func loadInventories() -> bool:
	print("loading inventories...")
	
	var data: Dictionary = getSavedData()
	var success: bool = true
	
	if not loadInventory(data):
		success = false
		print("Failed to load Inventory")
	if not loadHotbar(data):
		success = false
		print("Failed to load Hotbar")
	
	if success:
		print("Loaded inventories!")
	else:
		print("Failed to load inventories!")
	
	return success

static func loadInventory(data: Dictionary) -> bool:
	var rowsInv = data["rowsInv"]
	var colsInv = data["colsInv"]
	var slotsInv = data["slotsInv"]
	
	if not rowsInv or not colsInv or not slotsInv:
		print("Failed to initialize inventory data")
		return false
	
	var inv: Inventory = World.getCurrentInventory()
	
	if not inv:
		print("Failed to load inventory")
	
	loadItemsIntoInventory(inv, slotsInv)
	
	print("Ilegale item add")
	#inv.smartAddItem(load("res://Resources/testObject.tres"), 1)
	
	return true

static func loadHotbar(data: Dictionary) -> bool:
	var rowsHot = data["rowsHot"]
	var colsHot = data["colsHot"]
	var slotsHot = data["slotsHot"]
	var activeHot = data["activeHot"]
	
	if not rowsHot or not colsHot or not slotsHot or not activeHot:
		print("Failed to initialize inventory data")
		return false
	
	var hot: Inventory = World.getCurrentPlayer().hotbar
	
	if not hot:
		print("Failed to load hotbar")
		return false
	
	loadItemsIntoInventory(hot, slotsHot)
	hot.activateSlot(activeHot)
	return true

static func loadItemsIntoInventory(inv: Inventory, slots: Array) -> void:
	for i in range(len(slots)):
		for x in range(len(slots[i])):
			var parts = slots[i][x].split(".")
			var slotID = i * inv.columns + x + 1
			inv.setStack(slotID, World.getItem(parts[0]), int(parts[1]))

static func deleteGameFile() -> bool:
	var dir = DirAccess.open("user://")
	if dir:
		if dir.file_exists(save_path.get_file()):
			dir.remove(save_path.get_file())
			print("File removed!")
			return true
		print("File not found!")
		return false
		
	print("There is no dir!")
	return false

static func editGameFile() -> void:
	pass
