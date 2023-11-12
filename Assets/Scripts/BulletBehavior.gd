extends Area2D

@export var speed = 750
@export var enemy_group = "enemies"
@export var lifetime = 10

func _ready():
	born_to_die()

func born_to_die():
	# destroy after lifetime is over
	await get_tree().create_timer(lifetime).timeout
	queue_free()

# apply movement
func _physics_process(delta):
	position += transform.x * speed * delta

# delete enemy if I touch them, also delete myself no matter what
func _on_Bullet_body_entered(body):
	if body.is_in_group(enemy_group):
		body.queue_free()
	queue_free()
