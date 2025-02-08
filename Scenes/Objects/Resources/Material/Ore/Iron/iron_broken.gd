extends StaticBody3D


func _on_timer_timeout() -> void:
	var iron = load("res://Scenes/Objects/Resources/Material/Ore/Iron/iron.tscn")
	var instance = iron.instantiate()
	instance.position = self.position
	get_parent().add_child(instance)
	queue_free()
