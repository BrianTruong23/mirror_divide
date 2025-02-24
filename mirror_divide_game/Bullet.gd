extends Area2D

@export var speed: float = 500.0
var bullet_direction = Vector2.ZERO

func _ready():
	add_to_group("projectiles")

func _process(delta: float) -> void:
	position += bullet_direction * speed * delta

func _on_area_entered(area):
	pass  # Not needed for RigidBody2D detection

func _on_body_entered(body):
	if body.is_in_group("breakable"):  # Check if it's a breakable box
		body.call("break_box")  # Call the box's break function
		queue_free()  # Remove the bullet after hitting
