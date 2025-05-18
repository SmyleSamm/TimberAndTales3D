extends Control

@export var recipies: Array[Recipe]

@onready var vBox: VBoxContainer = $ScrollContainer/VBoxContainer

var combi: Array[Array] = [] #Array[Array[Recipie, HBoxContainer]]

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
		
		var ar: Array = []
		ar.append(i)
		ar.append(rec)
		combi.append(ar)
		
func _createRecipieUI(rec: Recipe) -> HBoxContainer:
	var ui: HBoxContainer = HBoxContainer.new()
	
	var itemsLeft: Array[ItemDrops] = rec.requirements
	var itemsRight: Array[ItemDrops] = rec.item
	var modifier: int = rec.currentModifier
	
	ui.add_child(_getItemScroll(itemsLeft, modifier))
	ui.add_theme_constant_override("separation", 10)
	ui.add_child(_getItemScroll(itemsRight, modifier))
	ui.add_child(_getCraftingButtons(rec))
	
	return ui
	
func _getItemScroll(res: Array[ItemDrops], modifier: int) -> ScrollContainer:
	var scroll: ScrollContainer = ScrollContainer.new()
	var vbox: VBoxContainer = VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	for i in res:
		vbox.add_child(_getItemList(i, modifier))
	scroll.add_child(vbox)
	scroll.custom_minimum_size = Vector2(170, 70)
	return scroll
	
func _getItemList(res: ItemDrops, mod: int) -> HBoxContainer:
	var hBox: HBoxContainer = HBoxContainer.new()
	
	var sprite: TextureRect = TextureRect.new()
	if res.item:
		sprite.texture = res.item.icon
		var name: String = res.item.name
		var count: int = res.maxCount * mod
	
	var text: Label = Label.new()
	text.text = _getLabelText(res, mod)
	
	hBox.add_child(sprite)
	hBox.add_child(text)
	
	return hBox

func _getLabelText(res: ItemDrops, mod: int) -> String:
	#FIXME: idk why, but res.item is <null> 
	if res.item:
		print("res.item is not null")
		var name: String = res.item.name
		var count: int = res.maxCount * mod
		return name + ": " + str(count)
	print("res.item is null")
	return ""

func _getCraftingButtons(recipie: Recipe) -> HBoxContainer:
	var hBox: HBoxContainer = HBoxContainer.new()
	
	var increase: CraftButton = preload("res://Scenes/UiElements/increase_button.tscn").instantiate()
	var decrease: CraftButton = preload("res://Scenes/UiElements/decrease_button.tscn").instantiate()
	var craft: CraftButton = preload("res://Scenes/UiElements/crafting_button.tscn").instantiate()
	var label: Label = Label.new()
	label.text = str(recipie.currentModifier)
	
	increase.init(self, recipie)
	decrease.init(self, recipie)
	craft.init(self, recipie)
	
	hBox.add_child(craft)
	hBox.add_child(increase)
	hBox.add_child(decrease)
	hBox.add_child(label)
	return hBox

func _addDivider() -> ColorRect:
	var rec: ColorRect = ColorRect.new()
	
	rec.custom_minimum_size = Vector2(540,5)
	rec.color = Color.WHITE
	
	return rec

func update(rec: Recipe) -> void:
	for i in len(combi):
		if combi[i][0] == rec:
			updateCraftingUI(combi[i][1], rec)

func updateCraftingUI(box: HBoxContainer, rec: Recipe) -> void:
	var children: Array = box.get_children()
	
	var left: ScrollContainer = children[0]
	var middle: ScrollContainer = children[1]
	
	#maybe for updating mod
	var rightLabel: Label = children[2].get_children()[3]
	var leftLabels: Array = getLabels(left)
	var middleLabels: Array = getLabels(middle)
	
	#_getLabelText(rec.item[0], rec.currentModifier)
	for i in len(leftLabels):
		leftLabels[i].text = _getLabelText(rec.requirements[i], rec.currentModifier)
	for i in len(middleLabels):
		middleLabels[i].text = _getLabelText(rec.item[i], rec.currentModifier)
	rightLabel.text = str(rec.currentModifier)
	
func getLabels(box: ScrollContainer) -> Array:
	var hBox: Array = box.get_children()[0].get_children()
	var labels: Array = []
	for n in hBox:
		labels.append(n.get_children()[1])
	return labels
