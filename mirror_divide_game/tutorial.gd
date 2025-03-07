extends Node2D

@onready var restart_label = $RestartLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Optionally hide the label initially
	restart_label.visible = false

func _on_canvas_layer_restart() -> void:
	# Set restart label to the center of the screen
	restart_label.global_position = (Vector2(get_viewport().size) + Vector2(100,0)) / 2
	# Make the label visible
	restart_label.visible = true
	
	# Pause the game
	get_tree().paused = true
	
	# Make sure the restart label still processes while paused
	restart_label.process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Force UI update BEFORE waiting
	await get_tree().process_frame
	
	# Create a timer that works in paused state
	var timer = get_tree().create_timer(2.0, true)
	await timer.timeout
	
	# Unpause before restarting
	get_tree().paused = false
	
	# Restart the game by reloading the current scene
	get_tree().reload_current_scene()
