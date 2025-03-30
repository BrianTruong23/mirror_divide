extends Node2D

@onready var label_text = $CanvasLayer/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label_text.visible = false 


func _on_researcher_final_game_ended() -> void:
	# Get the viewport size
	var viewport_size = get_viewport_rect().size
	
	# Set the global position to center
	label_text.global_position = Vector2(viewport_size.x / 2, viewport_size.y / 2) - label_text.size / 2
	
	label_text.visible = true 
	
	get_tree().paused = true 
