extends Camera2D

@export var player1: CharacterBody2D = null
@export var player2: CharacterBody2D = null
@export var zoom_normal: Vector2 = Vector2(1, 1)  # Normal zoom level
@export var zoom_in: Vector2 = Vector2(1.5, 1.5)  # Zoom-in level
@export var zoom_speed: float = 5.0  # Zoom transition speed

var current_target: CharacterBody2D = null  # Start without a target

func _ready() -> void:
	# Wait until both players exist before setting the target
	if player1 == null or player2 == null:
		print("Error: Player1 or Player2 is not assigned to CameraController.")
		return

	# Start with Player 1 as the initial focus
	current_target = player1
	position = current_target.position  # Set camera position
	zoom = zoom_normal  # Set default zoom level

func _process(delta: float) -> void:
	# Ensure players exist before accessing their properties
	if player1 == null or player2 == null:
		return  # Prevent errors if players are not assigned

	# Switch camera view when "camera_switch" key is pressed
	if Input.is_action_just_pressed("camera_switch"):
		toggle_target()

	# Smoothly move the camera towards the current target
	if current_target:
		position = position.lerp(current_target.position, delta * 5)  # Smooth follow

	# Smooth zoom transition
	zoom = zoom.lerp(zoom_in if zoom != zoom_normal else zoom_normal, delta * zoom_speed)

func toggle_target():
	if current_target == player1:
		current_target = player2
	else:
		current_target = player1
	
