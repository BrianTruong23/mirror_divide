extends AudioStreamPlayer

func _ready():
	connect("finished", _on_audio_finished)
	play()

func _on_audio_finished():
	play()
