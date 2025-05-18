extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in get_children():
		i.hide()

func interact() -> void:
	for i in get_children():
		if i.name == "main_menu":
			World.getCurrentPlayer().openUI(i)
	#print(get_children()[0].name)
