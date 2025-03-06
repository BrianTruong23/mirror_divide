extends CharacterBody2D

@onready var anim = $Area2D/AnimatedSprite2D  # Reference to AnimationPlayer
signal lever_activated  # Define a signal for the doors

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body is RigidBody2D and body.is_in_group("rock"):
		lever_activated.emit()  # Emit signal to open the doors
		anim.play("open")  # Play lever animation
