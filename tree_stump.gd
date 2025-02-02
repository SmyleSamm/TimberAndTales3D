extends StaticBody3D

func _on_timer_timeout() -> void:
	var tree = load("res://tree.tscn")
	var instance = tree.instantiate()
	instance.position = self.position
	get_parent().add_child(instance)
	queue_free()
