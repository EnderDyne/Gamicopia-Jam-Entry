extends Area2D

@export var enemy_group = "enemies"
var speed
var lifetime
var is_enemy = false
var damage_amount : int
var pierce : bool

func _ready():
	born_to_die()

func born_to_die():
	# destroy after lifetime is over
	await get_tree().create_timer(lifetime).timeout
	queue_free()

# apply movement
func _physics_process(delta):
	position += transform.x * speed * delta

func hit_enemy():
	if !pierce:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("walls"):
		queue_free()
