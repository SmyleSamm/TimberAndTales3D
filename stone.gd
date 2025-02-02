extends Minable

func spawn_stone_broken() -> void:
	var stone_broken = preload("res://stone_broken.tscn")
	var instance = stone_broken.instantiate()
	instance.position = position
	get_parent().add_child(instance)

func _on_destroyed() -> void:
	spawn_stone_broken()
