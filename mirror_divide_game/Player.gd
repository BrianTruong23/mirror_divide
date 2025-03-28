extends CharacterBody2D

@export var bullet_scene := preload("res://Bullet.tscn")  # Path to bullet scene
@export var max_health := 100

# Heart
@onready var heart_container: HBoxContainer = $HeartUI/HBoxContainer
@export var heart_value := 20  # Each heart represents 20 health
@export var full_heart_texture: Texture
@export var empty_heart_texture: Texture

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 1000.0
const BULLET_SPEED = 500.0

@onready var sprite = $AnimatedSprite2D  # Reference to player sprite

var health: int
var can_transition = true  # Flag to prevent multiple transitions
var has_key = false  # Tracks key possession
var levels = [
	"res://tutorial.tscn",
	"res://level_1.tscn",
	"res://level_2.tscn",
	"res://level_3.tscn"
]

var current_level_index = 0
func _ready():
	add_to_group("player")  # Ensure player is in the correct group
	health = max_health
	full_heart_texture = load("res://assetss/heart_full.png")
	empty_heart_texture = load("res://assetss/heart.png")

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
	if not can_transition:  # ✅ Prevent repeated calls within short duration
		return
		
	can_transition = false  # 🚫 Disable further transitions temporarily
		
	if current_level_index < levels.size() - 1:
		current_level_index += 1  # Move to the next level
		print("Switching to:", levels[current_level_index])  # Debugging log
		TransitionManager.next_scene_path = levels[current_level_index]
		TransitionManager.play_fade()

		# ✅ Re-enable transition after 3 seconds (adjust as needed)
		await get_tree().create_timer(10.0).timeout
		can_transition = true  # ✅ Allow new transitions

func player_shoot():
	if not bullet_scene:
		print("Bullet scene is not assigned!")
		return

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

func update_hearts():
	var hearts_to_show = ceil(float(health) / heart_value)
	for i in range(heart_container.get_child_count()):
		var heart = heart_container.get_child(i)
		if i < hearts_to_show:
			heart.texture = full_heart_texture
		else:
			heart.texture = empty_heart_texture

func take_damage(damage: int):
	health -= damage
	print(name, " took ", damage, " damage! Health: ", health)
	update_hearts()
	if health <= 0:
		die()

func die():
	print(name, " has died!")
	queue_free()  # Remove player from the game
