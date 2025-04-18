extends CharacterBody2D

const GRAVITY = 1000
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const BULLET_SPEED = 500.0

#@onready var label_text = $CanvasLayer/Label
signal final_game_ended

func _ready():
	# Assuming you have an Area2D as a child node called "DetectionArea"
	# Connect its body_entered signal to a function in this script
	$Area2D.body_entered.connect(_on_detection_area_body_entered)
	#label_text.visible = false 

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	# Move and check for collisions
	move_and_slide()

func _on_detection_area_body_entered(body):
	# Check if the colliding body is another CharacterBody2D
	if body is CharacterBody2D and body != self and body.is_in_group("player"):
		print("Game stopped - Collision detected with: ", body.name)
		#emit_signal("final_game_ended")  # Optional, in case other systems use this

		# Transition to final scene (after fade if needed)
		TransitionManager.next_scene_path = "res://Scene/final.tscn"
		await TransitionManager.play_fade()
