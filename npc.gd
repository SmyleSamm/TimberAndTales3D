class_name NPC extends StaticBody3D

var player: Player

func _ready() -> void:
	Dialogic.timeline_started.connect(_on_dialogic_started)
	Dialogic.timeline_ended.connect(_on_dialogic_ended)
	self.player = World.getCurrentPlayer()
	var scan: Area3D = World.createScan(self)
	scan.connect("body_entered", Callable(self, "_on_scan_body_entered"))
	scan.connect("body_exited", Callable(self, "_on_scan_body_exited"))

func _on_scan_body_entered(body) -> void:
	body.look.inRange(self)

func _on_scan_body_exited(body) -> void:
	body.look.tooFaar(self)

func talkToPlayer() -> void:
	print("Talked to")
	#SaveGame.saveGame()
	World.lastNPC = self
	Dialogic.start("timeline")

func checkIfQuestCompleted(args: String) -> void:
	print(args)
	print("-------")
	#for i in args:
	var item: Item = load("res://Resources/ItemData/"+args+".tres")
	print(item)
	var count: int = World.getPlayerResourceCount(item)
	print(count)
	Dialogic.VAR.FirstPerson.Quests.AAAC = count
	
func _on_dialogic_started():
	if player:
		player.setDialogue(true)
	else:
		printerr("Player not found!")

func _on_dialogic_ended():
	if player:
		player.setDialogue(false)
	else:
		printerr("Player not found!")
