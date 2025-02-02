extends Control

@export var recipies: Array[Recipe]

@onready var vBox: VBoxContainer = $ScrollContainer/VBoxContainer

func _ready() -> void:
	if not vBox:
		vBox = VBoxContainer.new()
	_initializeUI()
	
func _initializeUI() -> void:
	#for every recipie
	for i in recipies:
		i.currentModifier = 1
		var rec: HBoxContainer = _createRecipieUI(i)
		vBox.add_child(rec)
		vBox.add_child(_addDivider())
func _createRecipieUI(rec: Recipe) -> HBoxContainer:
	var ui: HBoxContainer = HBoxContainer.new()
	var itemsLeft: Array[ItemDrops] = rec.requirements
	var itemsRight: Array[ItemDrops] = rec.item
	ui.add_child(_getItemScroll(itemsLeft))
	ui.add_theme_constant_override("separation", 30)
	ui.add_child(_getItemScroll(itemsRight))
	ui.add_child(_getCraftingButtons(rec))
	return ui
	
func _getItemScroll(res: Array[ItemDrops]) -> ScrollContainer:
	var scroll: ScrollContainer = ScrollContainer.new()
	var vbox: VBoxContainer = VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	for i in res:
		vbox.add_child(_getItemList(i))
	scroll.add_child(vbox)
	scroll.custom_minimum_size = Vector2(170, 70)
	return scroll
	
func _getItemList(res: ItemDrops) -> HBoxContainer:
	var hBox: HBoxContainer = HBoxContainer.new()
	
	var sprite: TextureRect = TextureRect.new()
	sprite.texture = res.item.icon
	var name: String = res.item.name
	var count: int = res.maxCount
	
	var text: Label = Label.new()
	text.text = name + ": " + str(count)
	
	hBox.add_child(sprite)
	hBox.add_child(text)
	
	return hBox

func _getCraftingButtons(recipie: Recipe) -> HBoxContainer:
	var hBox: HBoxContainer = HBoxContainer.new()
	
	var increase: CraftButton = preload("res://increase_button.tscn").instantiate()
	var decrease: CraftButton = preload("res://decrease_button.tscn").instantiate()
	var craft: CraftButton = preload("res://crafting_button.tscn").instantiate()
	
	increase.init(self, recipie)
	decrease.init(self, recipie)
	craft.init(self, recipie)
	
	hBox.add_child(craft)
	hBox.add_child(increase)
	hBox.add_child(decrease)
	
	return hBox

func _addDivider() -> ColorRect:
	var rec: ColorRect = ColorRect.new()
	rec.custom_minimum_size = Vector2(540,5)
	rec.color = Color.WHITE
	return rec
