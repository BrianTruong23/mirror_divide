extends CharacterBody2D

@onready var platform_camera = Camera2D

func _on_lever_platform_raised() -> void:
	
	position += Vector2(0, -210)  # Move up by 50 pixels
