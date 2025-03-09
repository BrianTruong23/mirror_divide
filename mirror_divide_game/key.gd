extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.has_key = true  # Set a flag on the player
		queue_free()  # Remove the key
