extends TextureButton

func _ready():
	pressed.connect(start_game)

func start_game():
	TransitionManager.next_scene_path = "res://tutorial.tscn"
	TransitionManager.play_fade()
