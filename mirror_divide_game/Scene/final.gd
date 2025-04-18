extends Node2D

func _ready():
	await get_tree().create_timer(3.0).timeout  # Wait 3 seconds on final screen

	GlobalHealth.reset_health()
	GlobalHealth.update_hearts()

	TransitionManager.next_scene_path = "res://title.tscn"
	await TransitionManager.play_fade()
