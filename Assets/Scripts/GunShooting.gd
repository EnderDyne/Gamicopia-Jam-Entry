extends Sprite2D

@onready var reload_ui = get_node("../../ReloadUI")
@onready var player_inventory = get_node("../../../PlayerInventory")

var rng = RandomNumberGenerator.new()

enum AmmoType {pistol, rifle, shotgun, explosive}

var can_shoot = true
var is_reloading = false
var is_shooting = false
var gun_index : int
var equipped_gun : Resource

# hide the reload bar ui and setup the gun
func _ready():
	reload_ui.hide()
	switch_to_gun(0)
	update_ui()

# check for input
func _process(delta):
	if Input.is_action_pressed("shoot") and !is_reloading and can_shoot:
		if player_inventory.loaded_ammo[gun_index] > 0:
			shoot()
	
	if (Input.is_action_just_pressed("reload") || (Input.is_action_just_pressed("shoot")) && player_inventory.loaded_ammo[gun_index] == 0) and player_inventory.loaded_ammo[gun_index] < equipped_gun.mag_size and !is_reloading:
		reload()
	
	if Input.is_action_just_pressed("switch_gun") and !is_reloading and !is_shooting and !Input.is_action_pressed("shoot"):
		var index = gun_index + 1
		if(index >= player_inventory.equipped_guns.size()):
			index = 0
		switch_to_gun(index)

func equip_new_gun(gun_index : int, gun_resource : Resource):
	player_inventory.equipped_guns[gun_index] = gun_resource
	player_inventory.loaded_ammo[gun_index] = gun_resource.mag_size

func switch_to_gun(new_gun_index : int):
	equipped_gun = player_inventory.equipped_guns[new_gun_index]
	gun_index = new_gun_index
	
	
	update_ui()

# shoot bullets
func shoot():
	is_shooting = true
	
	for n in equipped_gun.burst_count:
		get_node("../../Camera2D").apply_shake(equipped_gun.shoot_shake, equipped_gun.shoot_shake_fade)
		player_inventory.loaded_ammo[gun_index] -= 1
		update_ui()
		create_bullet()
		
		if(player_inventory.loaded_ammo[gun_index] <= 0):
			player_inventory.loaded_ammo[gun_index] = 0
			break
		
		await get_tree().create_timer(equipped_gun.burst_delay).timeout
	
	is_shooting = false

# instantiate a bullet and set its transform to the base node
func create_bullet():
	# repeat times bullet_count
	for n in equipped_gun.bullet_count:
		var b = equipped_gun.bullet_scene.instantiate()
		
		# setup bullet
		b.speed = equipped_gun.bullet_speed
		b.lifetime = equipped_gun.bullet_lifetime
		b.damage_amount = equipped_gun.bullet_damage
		
		owner.add_child(b)
		b.transform = $SpawnPos.global_transform
		
		# apply spread
		b.rotate(deg_to_rad(rng.randf_range(-equipped_gun.bullet_spread, equipped_gun.bullet_spread)/2))
	
	# pause before letting you shoot again
	can_shoot = false
	await get_tree().create_timer(equipped_gun.shoot_delay).timeout
	can_shoot = true

# update the ammo ui
func update_ui():
	var format_string = "Ammo: %s/%s\n%s Ammo: %s\n%s"
	var ammo_type_string = AmmoType.keys()[equipped_gun.ammo_type].capitalize()
	var final_string = format_string % [player_inventory.loaded_ammo[gun_index], equipped_gun.mag_size, ammo_type_string, player_inventory.stored_ammo[equipped_gun.ammo_type], equipped_gun.gun_name]
	
	get_node("/root/Node2D/CanvasLayer/UI/AmmoUI").text = final_string

# do the reload bar animation, wait, then refill the gun's ammo
func reload():
	is_reloading = true
	do_reload_bar()
	await get_tree().create_timer(equipped_gun.reload_time).timeout
	
	# reload and decrease stored ammo of the gun's type by amount you have to reload
	if(equipped_gun.mag_size - player_inventory.loaded_ammo[gun_index] > player_inventory.stored_ammo[equipped_gun.ammo_type]):
		player_inventory.loaded_ammo[gun_index] = player_inventory.stored_ammo[equipped_gun.ammo_type]
		player_inventory.stored_ammo[equipped_gun.ammo_type] = 0
	else:
		player_inventory.stored_ammo[equipped_gun.ammo_type] -= equipped_gun.mag_size - player_inventory.loaded_ammo[gun_index]
		player_inventory.loaded_ammo[gun_index] = equipped_gun.mag_size
	
	update_ui()
	is_reloading = false
	reload_ui.hide()

# reload bar animation
func do_reload_bar():
	reload_ui.show()
	
	var reload_line = get_node("../../ReloadUI/ReloadBar/ReloadLine")
	reload_line.position = Vector2(145, -12.5)
	
	var tween = create_tween()
	tween.tween_property(reload_line, "position", Vector2(0, -12.5), equipped_gun.reload_time)
