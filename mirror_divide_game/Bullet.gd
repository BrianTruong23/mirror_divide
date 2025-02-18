extends Area2D

@export var BULLET_LIFETIME = 3.0  # Bullet lifespan in seconds

var bullet_direction 

var speed = 800
	
func _process(delta):
	position -= bullet_direction * speed * delta

	# Check if the bullet is off-screen.
	var viewport_rect = get_viewport().get_visible_rect()
	if not viewport_rect.has_point(global_position):
		queue_free()
