extends Node

@onready var audio_player = $AudioStreamPlayer

func _ready():
	audio_player.connect("finished", _on_audio_finished)
	audio_player.play()

func _on_audio_finished():
	audio_player.play() # Replay the song when it ends
