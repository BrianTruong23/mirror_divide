extends CharacterBody2D

@export var bullet_scene := preload("res://Bullet.tscn")  # Path to bullet scene

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 1000.0
const BULLET_SPEED = 500.0

@onready var sprite = $AnimatedSprite2D  # Reference to player sprite
@onready var hit_sound = $HitSound  # Add this at the top with your other @onready vars

var can_transition = true  # Flag to prevent multiple transitions
var has_key = false  # Tracks key possession
var levels = [
	"res://tutorial.tscn",
	"res://level_1.tscn",
	"res://final_level.tscn",
]

var current_level_index = 0
func _ready():
	add_to_group("player")  # Ensure player is in the correct group
	
		# Dynamically detect current level index from scene path
	var current_scene_path = get_tree().current_scene.scene_file_path
	current_level_index = levels.find(current_scene_path)

func _physics_process(delta: float) -> void:
	
	# Apply gravity
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

	# Apply movement speed (NO EXTRA DELTA MULTIPLICATION)
	velocity.x = direction.x * SPEED

	# Handle animations
	if direction.x != 0:  # If moving, play run animation
		sprite.play("run")
	else:
		sprite.play("idle")  # Default to idle when not moving

	# Move and check for collisions
	move_and_slide()
	
	# Kill if fall
	if global_position.y > 2000:
		die()
	
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider and collider.name == "Player2":
			print("Collision with Player detected!")
			transition_to_next_level()

	# Handle shooting
	if Input.is_action_just_pressed("player_shoot"):
		print("left clicked")
		player_shoot()

func transition_to_next_level():
	if not can_transition:
		return

	can_transition = false
	GlobalHealth.reset_health() 

	if current_level_index < levels.size() - 1:
		current_level_index += 1
		var next_path = levels[current_level_index]
		print("Switching to:", next_path)

		GlobalHealth.is_final_level = current_level_index == levels.size() - 1

		TransitionManager.next_scene_path = next_path
		TransitionManager.play_fade()

		await get_tree().create_timer(10.0).timeout
		can_transition = true

func player_shoot():
	if not bullet_scene:
		print("Bullet scene is not assigned!")
		return

	$GunSound2.play()

	
	# Get the gun node and Muzzle marker
	var gun = $Gun  # Adjust if needed
	var muzzle = gun.get_node("Muzzle")  # Ensure the Muzzle marker exists

	# Create the bullet instance
	var bullet = bullet_scene.instantiate()
	bullet.position = muzzle.global_position  # Spawn at the Muzzle

	# **Fix bullet direction calculation**
	bullet.bullet_direction = (get_global_mouse_position() - bullet.position).normalized()

	# Add bullet to the scene
	get_parent().add_child(bullet)
	
func flash_blue():
	if sprite:
		sprite.modulate = Color(0.6, 0.7, 1.0, 0.9)
		await get_tree().create_timer(0.1).timeout
		sprite.modulate = Color(1, 1, 1)  # Reset to normal

func flash_orange():
	if sprite:
		sprite.modulate = Color(1.0, 0.6, 0.2, 0.9)  # Orange flash
		await get_tree().create_timer(0.1).timeout
		sprite.modulate = Color(1, 1, 1)

func take_damage(damage: int):
	if GlobalHealth.is_final_level:
		flash_orange()
	else:
		flash_blue()
	if hit_sound:
		$HitSound.play()

	GlobalHealth.apply_damage(damage)

func die():
	print(name, " has died!")
	queue_free()  # Remove player from the game
	GlobalHealth.reset_health()
	get_tree().reload_current_scene()
