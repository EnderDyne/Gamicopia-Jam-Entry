extends Camera2D

@export var default_random_strength: float = 30.0
# NOTE: the higher the fade value, the faster the shake fades out
@export var default_shake_fade: float = 5.0

var random_strength: float = 0
var shake_fade: float = 0

var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0

# call to shake the camera
func apply_shake(strength: float = default_random_strength, fade: float = default_shake_fade):
	random_strength = strength
	shake_fade = fade
	shake_strength = random_strength

func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))

func _process(delta):	
	# apply shaking effect to camera offset
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		offset = random_offset()
