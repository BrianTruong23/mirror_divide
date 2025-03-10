extends Area2D
signal key_acquired

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.has_key = true  # Set a flag on the player
		emit_signal('key_acquired')
		queue_free()  # Remove the key
