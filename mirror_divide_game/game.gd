extends Node2D

var reset_held_time = 0.0
var reset_threshold = 1.0  # Hold for 1 second to reset
@onready var canvas_layer_key = $CanvasLayerKey/Sprite2D
@onready var canvas_layer_label = $CanvasLayerKey/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	canvas_layer_key.position = Vector2(100, 100)  # Moves to the top-left
	canvas_layer_label.position = Vector2(150,100)
	canvas_layer_key.visible = false
	canvas_layer_label.visible = false 


	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var key = get_node_or_null("Level1Key")  # Find the key
	
	if key:
		key.key_acquired.connect(_on_door_key_acquired)  # Connect key signal


	if Input.is_action_pressed("reset"):
		reset_held_time += delta
		if reset_held_time >= reset_threshold:
			reset_level()
	else:
		reset_held_time = 0.0
		
func reset_level():
	get_tree().reload_current_scene()


func _on_door_key_acquired() -> void:
	print("key_acquired")
	canvas_layer_key.visible = true 
	canvas_layer_label.visible = true 
