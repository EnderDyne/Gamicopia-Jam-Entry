extends CharacterBody2D

@export var speed = 400

@export var dash_speed = 1000
@export var dash_time = 0.2

@export var dash_shake = 10
@export var dash_shake_fade = 5

var dash_dir
var cur_dash_time = 0

func get_input(delta):
	# 8 dir movement
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	# dash input
	if Input.is_action_just_pressed("dash"):
		# set direction and time
		dash_dir = input_direction
		cur_dash_time = dash_time
		# do screen shake
		$Camera2D.apply_shake(dash_shake, dash_shake_fade)
	
	# apply movement
	if(cur_dash_time <= 0):
		velocity = input_direction * speed
	else:
		cur_dash_time -= delta
		velocity = dash_dir * dash_speed

func _physics_process(delta):
	get_input(delta)
	move_and_slide()
