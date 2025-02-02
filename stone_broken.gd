extends StaticBody3D

func _on_timer_timeout() -> void:
	var stone = load("res://stone.tscn")
	var instance = stone.instantiate()
	instance.position = self.position
	get_parent().add_child(instance)
	queue_free()
