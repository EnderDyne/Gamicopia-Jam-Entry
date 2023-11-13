extends Resource

# this is a data container that holds all the values for different types
# of guns, you can add more values here to add more possible types of guns
@export var gun_name: String

@export_group("Ammo and Reloading")
enum AmmoType {pistol, rifle, shotgun, explosive}
@export var ammo_type: AmmoType
@export var mag_size: int = 12
@export var reload_time = 0.5

@export_group("Screen Shake")
@export var shoot_shake = 15
@export var shoot_shake_fade = 10

@export_group("Shoot Behavior")
@export var shoot_delay = 0.2
@export var bullet_count : int
# NOTE: bullet spread is in degrees
@export var bullet_spread : float

@export_group("Burst Behavior")
@export var burst_count = 1
@export var burst_delay : float

@export_group("Bullet Properties")
@export var bullet_scene : PackedScene
# TODO: knockback
@export var bullet_damage : int
# @export var bullet_knockback : float
@export var bullet_lifetime = 10
@export var bullet_speed = 750
