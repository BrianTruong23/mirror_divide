extends TextureButton

func _ready():
	pressed.connect(start_game)
	
func _on_button_pressed():
	$ClickSound.play()


func start_game():
	TransitionManager.next_scene_path = "res://tutorial.tscn"
	TransitionManager.play_fade()


func _on_pressed():
	$ClickSound.play()
