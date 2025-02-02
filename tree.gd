extends Minable

func spawn_tree_stump() -> void:
	var tree_stump = preload("res://tree_stump.tscn")
	var instance = tree_stump.instantiate()
	instance.position = position
	get_parent().add_child(instance)

func _on_destroyed() -> void:
	spawn_tree_stump()
