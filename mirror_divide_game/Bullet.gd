extends Area2D

@export var speed: float = 500.0
@export var max_distance: float = 300.0  # Max distance before disappearing
var bullet_direction = Vector2.ZERO
var start_position: Vector2

func _ready():
	add_to_group("projectiles")
	start_position = position  # Store the initial position
	collision_layer = 15  # Binary 00001111 (Layers 1 to 4)
	collision_mask = 15   # Binary 00001111 (Collides with Layers 1 to 4)

func _process(delta: float) -> void:
	position += bullet_direction * speed * delta
	
	# Remove bullet if it exceeds max travel distance
	if position.distance_to(start_position) > max_distance:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		return
	if body.has_method("take_damage"):
		body.take_damage(25)  # Or whatever bullet damage you want
		queue_free()  # Remove bullet
	if body.is_in_group("breakable"):  # Check if it's a breakable bo
		body.call("break_box")  # Call the box's break function
		queue_free()  # Remove the bullet after hitting
