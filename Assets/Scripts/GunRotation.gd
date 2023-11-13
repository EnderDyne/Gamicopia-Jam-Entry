extends Node2D

func _process(_delta):
	# point at the mouse
	look_at(get_global_mouse_position())
	# if on the left side, then flip upside down to look better
	$Gun.flip_v = (global_rotation_degrees < -90 or global_rotation_degrees > 90)
