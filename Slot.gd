class_name Slot extends Button

@export var item: Item

func _ready() -> void:
	if item:
		icon = item.icon

func getAttack() -> Attack:
	if item is Tool:
		return item.attack
	var attack: Attack = Attack.new()
	attack.base_damage = 10
	attack.base_lvl = 1
	return attack
