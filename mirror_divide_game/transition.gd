extends CanvasLayer

@onready var color_rect = $ColorRect  # Reference to the ColorRect
var next_scene_path = ""  # Store the next scene path

func play_fade():
	color_rect.visible = true  # Ensure transition is visible
	color_rect.modulate.a = 0.0  # Start transparent

	# Fade In (0.5s)
	for i in range(10):
		color_rect.modulate.a += 0.1
		await get_tree().create_timer(0.05).timeout

	# Wait for 2 seconds before switching scenes
	await get_tree().create_timer(2.0).timeout

	# Change scene
	if next_scene_path != "":
		get_tree().change_scene_to_file(next_scene_path)

	# Fade Out (0.5s)
	for i in range(10):
		color_rect.modulate.a -= 0.1
		await get_tree().create_timer(0.05).timeout

	color_rect.visible = false  # Hide transition
