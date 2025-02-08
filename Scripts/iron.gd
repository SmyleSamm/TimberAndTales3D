extends Minable

func spawn_iron_broken() -> void:
	var iron_broken = preload("res://Scenes/Objects/Resources/Material/Ore/Iron/iron_broken.tscn")
	var instance = iron_broken.instantiate()
	instance.position = position
	get_parent().add_child(instance)

func _on_destroyed() -> void:
	spawn_iron_broken()
