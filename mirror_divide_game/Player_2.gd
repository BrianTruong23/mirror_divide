extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 1000.0

@onready var sprite = $AnimatedSprite2D  # Reference to sprite
@onready var grab_area: Area2D = $GrabArea  # Make sure grab_area exists in scene

var grabbed_object: Node = null  # Store grabbed object reference
var can_transition = true  # Flag to prevent multiple transitions

var levels = [
	"res://tutorial.tscn",
	"res://level_1.tscn",
	"res://final_level.tscn",
]

var current_level_index = 0
func _ready():
	add_to_group("player")
	
	# Dynamically detect current level index from scene path
	var current_scene_path = get_tree().current_scene.scene_file_path
	current_level_index = levels.find(current_scene_path)

func _physics_process(delta: float) -> void:
	# Apply gravity if not on the floor
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Handle jump
	if Input.is_action_just_pressed("player_up_2") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		sprite.play("jump")

	# Get movement direction
	var direction = Vector2.ZERO
	if Input.is_action_pressed("player_left_2"):
		direction.x = -1
	if Input.is_action_pressed("player_right_2"):
		direction.x = 1

	# Apply movement speed
	velocity.x = direction.x * SPEED

	move_and_slide()
	
	if global_position.y > 2000:
		die()

	# Check for collision after movement
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider and collider.name == "Player":
			print("Collision with Player detected!")
			transition_to_next_level()

func transition_to_next_level():
	if not can_transition:  # ✅ Prevent repeated calls within short duration
		return
		
	can_transition = false  # 🚫 Disable further transitions temporarily
	
	if current_level_index < levels.size() - 1:
		current_level_index += 1  # Move to the next level
		print("Switching to:", levels[current_level_index])  # Debugging log
		GlobalHealth.reset_health() 
		TransitionManager.next_scene_path = levels[current_level_index]
		TransitionManager.play_fade()

		# ✅ Re-enable transition after 3 seconds (adjust as needed)
		await get_tree().create_timer(10.0).timeout
		can_transition = true  # ✅ Allow new transitions

func flash_blue():
	if sprite:
		sprite.modulate = Color(0.6, 0.7, 1.0, 0.9)
		await get_tree().create_timer(0.1).timeout
		sprite.modulate = Color(1, 1, 1)  # Reset to normal

func take_damage(damage: int):
	flash_blue()
	GlobalHealth.apply_damage(damage)

func die():
	print(name, " has died!")
	queue_free()  # Remove player from the game
	get_tree().reload_current_scene()
