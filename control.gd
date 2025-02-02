extends Control

@onready var fps: Label = $VBoxContainer/FPS

func _process(delta: float) -> void:
	fps.text = str(Engine.get_frames_per_second()) + " Fps"
