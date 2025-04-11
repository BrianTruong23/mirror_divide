extends CanvasLayer

@onready var color_rect = $ColorRect  # Reference to the ColorRect
var next_scene_path = ""  # Store the next scene path

func play_fade():
	var heart_ui = get_tree().get_root().find_child("HeartUI", true, false)
	if heart_ui:
		heart_ui.visible = false  # Hide heart UI during transition

	color_rect.visible = true
	color_rect.modulate.a = 0.0

	for i in range(10):
		color_rect.modulate.a += 0.1
		await get_tree().create_timer(0.05).timeout

	await get_tree().create_timer(2.0).timeout

	if next_scene_path != "":
		get_tree().change_scene_to_file(next_scene_path)

	for i in range(10):
		color_rect.modulate.a -= 0.1
		await get_tree().create_timer(0.05).timeout

	color_rect.visible = false

	if heart_ui:
		heart_ui.visible = true  # Show again after fade
	
	GlobalHealth.reset_health()
	GlobalHealth.update_hearts()
