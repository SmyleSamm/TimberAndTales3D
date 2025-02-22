class_name SelectItemUI extends Control

signal equip
signal split

var canEquip: bool
var canSplit: bool

func _ready() -> void:
	init()

func initButton(button: Button, text: String) -> Button:
	var label: Button = button
	label.theme = load("res://Resources/Fonts/pixelStyle.tres")
	label.scale = Vector2(0.5, 0.5)
	label.set_anchors_preset(Control.PRESET_TOP_LEFT)
	label.custom_minimum_size = Vector2(64, 0)
	label.position = Vector2(0, 24)
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 20)
	label.add_theme_color_override("font_color", Color.WHITE_SMOKE)
	label.text = text
	return label

func init() -> void:
	var vBox: VBoxContainer = VBoxContainer.new()
	
	var bEquip: Button = Button.new()
	var bSplit: Button = Button.new()
	
	bEquip = initButton(bEquip, "Equip")
	bSplit = initButton(bSplit, "Split")
	
	bEquip.pressed.connect(_on_equiped_pressed)
	bSplit.pressed.connect(_on_split_pressed)
	
	vBox.add_child(bEquip)
	vBox.add_child(bSplit)
	
	add_child(vBox)

func _on_equiped_pressed() -> void:
	equip.emit()

func _on_split_pressed() -> void:
	split.emit()
