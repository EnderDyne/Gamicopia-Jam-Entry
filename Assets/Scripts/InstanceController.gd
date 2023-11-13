extends Node

@export var max_hp : int = 100
@onready var hp = max_hp
@export var is_enemy : bool 

func _on_hitbox_area_entered(area):
	if area.is_enemy != is_enemy:
		area.hit_enemy()
		take_damage(area.damage_amount)

func take_damage(damage_amount : int):
	hp -= damage_amount
	if(hp <= 0):
		die()

func die():
	queue_free()
