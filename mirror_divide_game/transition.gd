extends CanvasLayer

@onready var color_rect = $ColorRect
var next_scene_path = ""

func play_fade():
	var heart_ui = get_tree().get_root().find_child("HeartUI", true, false)
	if heart_ui:
		heart_ui.visible = false  # Always hide before fade

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

	if heart_ui and should_show_heart_ui(next_scene_path):
		heart_ui.visible = true

	GlobalHealth.reset_health()
	GlobalHealth.update_hearts()

func should_show_heart_ui(path: String) -> bool:
	return path in [
		"res://tutorial.tscn",
		"res://level_1.tscn",
		"res://final_level.tscn"
	]
