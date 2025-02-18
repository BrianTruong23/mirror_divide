extends CharacterBody2D

@export var bullet_scene := preload("res://Bullet.tscn")  # Path to bullet scene

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 1000.0
const BULLET_SPEED = 500.0

@onready var sprite = $AnimatedSprite2D  # Get reference to AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Apply gravity if not on the floor
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Handle jump
	if Input.is_action_just_pressed("player_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		sprite.play("jump")  # Play jump animation

	# Get movement direction
	var direction = Vector2.ZERO
	if Input.is_action_pressed("player_left"):
		direction.x = -1
	if Input.is_action_pressed("player_right"):
		direction.x = 1

	# Apply movement speed
	velocity.x = direction.x * SPEED

	# Handle animations
	if direction.x != 0:  # If moving, play run animation
		sprite.play("run")
		sprite.flip_h = direction.x < 0  # Flip the sprite when moving left
	else:
		sprite.play("idle")  # Default to idle when not moving

	move_and_slide()

	# Handle shooting
	if Input.is_action_just_pressed("player_shoot"):
		player_shoot()


func player_shoot():
	if not bullet_scene:
		print("Bullet scene is not assigned!")
		return

	var bullet = bullet_scene.instantiate()
	bullet.position = position + Vector2(0, 12)  # Start at player's position
	
	bullet.bullet_direction = (position - get_global_mouse_position()).normalized()

	# Add the bullet to the scene
	get_parent().add_child(bullet)
