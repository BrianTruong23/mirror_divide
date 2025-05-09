extends CharacterBody2D

@onready var platform_camera = $Camera2D

func _on_lever_platform_raised() -> void:
	platform_camera.make_current()  # Activate camera

	var tween = get_tree().create_tween()
	
	# Zoom in smoothly
	tween.tween_property(platform_camera, "zoom", Vector2(1, 1), 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	# Move the platform smoothly
	tween.tween_property(self, "position", position + Vector2(0, 500), 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	await tween.finished  # Wait for movement to complete

	platform_camera.enabled = false  # Optionally, switch back
