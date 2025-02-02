extends Repairable

func _spawnCraftingStation() -> void:
	var craftingStation = preload("res://craftingstation.tscn")
	var instance = craftingStation.instantiate()
	instance.position = position
	get_parent().add_child(instance)
	
func _on_repaired() -> void:
	_spawnCraftingStation()
	queue_free()
