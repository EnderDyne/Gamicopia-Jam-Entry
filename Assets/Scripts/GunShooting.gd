extends Sprite2D

@export var bullet_scene : PackedScene

@export var shoot_shake = 15
@export var shoot_shake_fade = 10

@export var mag_size = 12
@export var stored_ammo = 100
@onready var cur_ammo = mag_size

@export var reload_time = 2
@export var shoot_delay = 0.2

var can_shoot = true
var is_reloading = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		if Input.is_action_pressed("shoot") and !is_reloading and can_shoot:
			if cur_ammo > 0:
				shoot()
			else:
				reload()
		
		if Input.is_action_just_pressed("reload") and cur_ammo < mag_size:
			reload()

func shoot():
	get_node("../../Camera2D").apply_shake(shoot_shake, shoot_shake_fade)
	cur_ammo -= 1
	update_ui()
	create_bullet()

func update_ui():
	var format_string = "Ammo = %s/%s\nIn Bag = %s"
	get_node("/root/Node2D/CanvasLayer/UI/AmmoUI").text = format_string % [cur_ammo, mag_size, stored_ammo]

func reload():
	is_reloading = true
	await get_tree().create_timer(reload_time).timeout
	
	# reload and decrease stored ammo by amount you have to reload
	stored_ammo -= mag_size - cur_ammo
	cur_ammo = mag_size
	update_ui()
	is_reloading = false

func create_bullet():
	var b = bullet_scene.instantiate()
	owner.add_child(b)
	b.transform = $SpawnPos.global_transform
	
	can_shoot = false
	await get_tree().create_timer(shoot_delay).timeout
	can_shoot = true
