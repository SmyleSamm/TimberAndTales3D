class_name Crafting extends StaticBody3D

@export var ui: Control

func _ready() -> void:
	ui.hide()
	var scan: Area3D = World.createScan(self)
	scan.connect("body_entered", Callable(self, "_on_scan_body_entered"))
	scan.connect("body_exited", Callable(self, "_on_scan_body_exited"))

func _on_scan_body_entered(body) -> void:
	body.look.inRange(self)

func _on_scan_body_exited(body) -> void:
	body.look.tooFaar(self)

func getUI() -> Control:
	return ui 
