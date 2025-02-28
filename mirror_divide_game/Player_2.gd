extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 1000.0

@onready var sprite = $AnimatedSprite2D  # Reference to sprite
@onready var grab_area: Area2D = null  # Reference to grab hitbox (Area2D)

var grabbed_object: Node = null  # Store grabbed object reference

#func _ready() -> void:
	## Ensure GrabArea exists before using it
	#if has_node("GrabArea"):
		#grab_area = $GrabArea
	#else:
		#print("Error: GrabArea node is missing from Player 2!")

func _physics_process(delta: float) -> void:
	# Apply gravity if not on the floor
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Handle jump
	if Input.is_action_just_pressed("player_up_2") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		sprite.play("jump")  # Play jump animation

	# Get movement direction
	var direction = Vector2.ZERO
	if Input.is_action_pressed("player_left_2"):
		direction.x = -1
	if Input.is_action_pressed("player_right_2"):
		direction.x = 1

	# Apply movement speed
	velocity.x = direction.x * SPEED

	move_and_slide()
