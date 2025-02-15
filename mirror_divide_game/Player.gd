extends CharacterBody2D

@export var bullet_scene := preload("res://Bullet.tscn")  # Path to bullet scene

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 1000.0  # Ensure same gravity as enemy
const BULLET_SPEED = 500.0  # Speed of bullets

func _physics_process(delta: float) -> void:
	# Apply gravity if not on the floor
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Handle jump (Uses your custom "player_up" input)
	if Input.is_action_just_pressed("player_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get movement direction from your custom inputs
	var direction = Vector2.ZERO
	if Input.is_action_pressed("player_left"):
		direction.x = -1
	if Input.is_action_pressed("player_right"):
		direction.x = 1

	# Apply movement speed
	velocity.x = direction.x * SPEED

	move_and_slide()

	# Handle shooting with left mouse click
	if Input.is_action_just_pressed("player_shoot"):
		player_shoot()

func player_shoot():
	var bullet = bullet_scene.instantiate()
	bullet.position = position  # Start at player's position

	# Calculate the direction towards the cursor
	var mouse_position = get_global_mouse_position()
	var shoot_direction = (mouse_position - position).normalized()  # Get normalized direction

	# Ensure the bullet moves in the intended direction
	bullet.set_linear_velocity(shoot_direction * BULLET_SPEED)  # Use RigidBody2D's method

	# Add the bullet to the scene
	get_parent().add_child(bullet)
