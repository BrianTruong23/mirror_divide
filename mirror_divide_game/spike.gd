extends RigidBody2D

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):  # Check if it’s the player
		get_node("/root/Game").reset_level()  # Reset the level

# Optional: Keep RigidBody2D physics behavior
func _ready():
	freeze = true  # Optional: Make spikes static if desired
	gravity_scale = 0  # Optional: No falling
	get_node("/root/Game").connect("key_acquired_signal", Callable(self, "_on_key_acquired"))

func _on_key_acquired():
	queue_free() 
