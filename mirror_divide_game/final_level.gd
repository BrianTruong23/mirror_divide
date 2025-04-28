extends Node2D

@onready var label_text = $CanvasLayer/Label
@onready var game_win_sound = $GameWinSound


var reset_held_time = 0.0
var reset_threshold = 1.0  # Hold for 1 second to reset

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label_text.visible = false 


func _on_researcher_final_game_ended() -> void:
	if game_win_sound:
		game_win_sound.play()
		await game_win_sound.finished
	
	# Get the viewport size
	var viewport_size = get_viewport_rect().size
	
	# Set the global position to center
	label_text.global_position = Vector2(viewport_size.x / 2, viewport_size.y / 2) - label_text.size / 2
	
	label_text.visible = true 

	get_tree().paused = true 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("reset"):
		reset_held_time += delta
		if reset_held_time >= reset_threshold:
			reset_level()
	else:
		reset_held_time = 0.0
		
func reset_level():
	get_tree().reload_current_scene()
	GlobalHealth.reset_health() 
