class_name PopupLabel extends Label3D

func _ready():
	#text = "TESTY"
	scale = Vector3.ONE

	var font := load("res://Resources/Fonts/pixelStyle.tres")
	if font:
		set("theme_override_fonts/font", font)
	else:
		print("Font failed to load")
	
	#call_deferred("play_scale_animation")

func setUp(object: Node3D, text: String, offset: Vector3, labelRotation: Vector3) -> void:
	self.text = text
	#global_transform.basis = Basis.from_euler(labelRotation)
	transform.origin = object.position + offset
	object.get_tree().current_scene.add_child(self)

func play_scale_animation():
	print("Playing scale animation")
	var anim_player = AnimationPlayer.new()
	add_child(anim_player)

	var anim_lib = AnimationLibrary.new()
	anim_player.add_animation_library("", anim_lib)

	var anim = Animation.new()
	anim.length = 2.0
	var track = anim.add_track(Animation.TYPE_SCALE_3D)
	
	anim.track_set_path(track, ":scale")
	
	anim.track_insert_key(track, 0.0, Vector3(1, 1, 1))
	anim.track_insert_key(track, 2.0, Vector3(4, 4, 4))
	anim_lib.add_animation("scale_up", anim)

	anim_player.play("scale_up")

#pL.setUp(self, offset, text)
