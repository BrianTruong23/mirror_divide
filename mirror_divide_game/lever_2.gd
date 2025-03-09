extends CharacterBody2D

@onready var anim = $Area2D/AnimatedSprite2D  # Reference to AnimationPlayer
signal lever_activated  # Define a signal for the doors

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.area_entered.connect(_on_area_entered)  # Add this for Area2D detection

func _on_body_entered(body):
	if body is RigidBody2D and body.is_in_group("rock"):
		lever_activated.emit()  # Emit signal to open the doors
		anim.play("open")  # Play lever animation
		
func _on_area_entered(area): 
	print("Area detected:", area)
	anim.play("open") 
	lever_activated.emit()
