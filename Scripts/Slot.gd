class_name Slot extends Button

@export var item: Item

@onready var label: Label

func _ready() -> void:
	if item:
		icon = item.icon
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
		label.theme = load("res://Resources/Fonts/pixelStyle.tres")
		label.scale = Vector2(0.5, 0.5)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		label.set_anchors_preset(Control.PRESET_TOP_LEFT)
		label.custom_minimum_size = Vector2(64, 0)
		label.position = Vector2(0, 24)
		label.add_theme_color_override("font_outline_color", Color.BLACK)
		label.add_theme_constant_override("outline_size", 20)
		label.add_theme_color_override("font_color", Color.WHITE_SMOKE)
		add_child(label)
	
	label.text = labelText
