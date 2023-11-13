extends Node2D

# for some reason, Godot doesn't let you export arrays of custom classes,
# so instead, I had to do this. The loaded ammo array represents the ammo
# of the coresponding equipped gun, the arrays should always be the same length
@export var equipped_guns : Array[Resource]
@export var loaded_ammo: Array[int]

# ammo stored of the 4 ammo types: pistol, uzi, shotgun, and explosive
@export var stored_ammo: Array[int] = [100, 50, 50, 10]
