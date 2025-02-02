extends CanvasLayer

var resources: Array[Item] = []

var labels: Array[LabelStack]
var needsUpdate: bool = false
var counter_container: VBoxContainer

func changeResources(resource: Item, value: int) -> void:
	if not resource in resources:
		resources.append(resource)
		addNewCounter(resource)
	for i in resources:
		if i == resource:
			i.stackSize += value
			break
	needsUpdate = true

func _process(delta: float) -> void:
	if needsUpdate:
		_update()
		needsUpdate = false

func _update() -> void:
	for i in labels:
		var label: Label = i.label
		var item: Item = i.item
		label.text = getCounterText(item)

func checkIfCounterContainer() -> void:
	if counter_container:
		return
	if get_node("counterContainer"):
		counter_container = get_node("counterContainer")
	else:
		printerr("No counterContainer")
		
func addNewCounter(item: Item) -> void:
	checkIfCounterContainer()
	var newLabelStack: LabelStack = LabelStack.new()
	var hBox: HBoxContainer = HBoxContainer.new()
	var sprite: TextureRect = TextureRect.new()
	sprite.texture = item.icon
	var label: Label = Label.new()
	label.text = item.name
	hBox.add_child(sprite)
	hBox.add_child(label)
	counter_container.add_child(hBox)
	
	newLabelStack.item = item
	newLabelStack.label = label
	
	labels.append(newLabelStack)
	
func getCounterText(item: Item) -> String:
	var itemName: String = item.name
	var itemSize: String = str(item.stackSize)
	var text = itemName+": "+itemSize
	return text
