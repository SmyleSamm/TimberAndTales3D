class_name Slot extends Button

@export var item: Item

@onready var label: Label = $Label

func _ready() -> void:
	if item:
		icon = item.icon
		if not label:
			label = Label.new()
		updateLabel()
func getAttack() -> Attack:
	if item is Tool:
		return item.attack
	var attack: Attack = Attack.new()
	attack.base_damage = 10
	attack.base_lvl = 1
	return attack

func updateLabel() -> void:
	var labelText: String = str(item.stackSize)
	if not label:
		label = Label.new()
	label.text = labelText
	print(label.text)
	print("Self ",position)
	print("Label ",label.position)
	#label.top_level = true
