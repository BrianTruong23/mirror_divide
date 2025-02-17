extends RigidBody2D

func _ready():
	gravity_scale = 0  # Ensure bullet doesn't fall down

func _physics_process(delta):
	# If you need the bullet to destroy itself after a while
	if position.length() > 5000:  # Example limit
		queue_free()
