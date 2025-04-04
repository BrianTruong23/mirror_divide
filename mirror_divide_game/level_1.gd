extends Node2D

var reset_held_time = 0.0
var reset_threshold = 1.0  # Hold for 1 second to reset
@onready var canvas_layer_key = $CanvasLayerKey/Sprite2D
@onready var canvas_layer_label = $CanvasLayerKey/Label
@onready var end_game_label = $CanvasLayer/EndGameLabel

signal key_acquired_signal

# Called when the node enters the scene tree for the first time.
func _ready():
	setting_collision_layer_level()
	

func setting_collision_layer_level():
	await get_tree().process_frame  # Ensures this runs after the scene loads
	var root = get_tree().current_scene

	for body in root.get_children():
		if body is RigidBody2D or body is CharacterBody2D or body is StaticBody2D:
		
			if body == null:
				continue  # Skip if the body is null
				
			if "RigidBody" in body.name:  # Check if the name contains "RigidBody"
				body.collision_layer = 2
				body.collision_mask = 2

			elif "KeyBox" in body.name:
				print(body.name)
				body.collision_layer = 1
				body.collision_mask = 1

			else: 
				body.collision_layer = 15  
				body.collision_mask = 15
			
 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("reset"):
		reset_held_time += delta
		if reset_held_time >= reset_threshold:
			reset_level()
	else:
		reset_held_time = 0.0
		
	var key = get_node_or_null("Level1Key")  # Find the key

	if key:
		key.key_acquired.connect(_on_door_key_acquired)  # Connect key signal
		
func reset_level():
	get_tree().reload_current_scene()
	
	

func _on_door_key_acquired() -> void:
	var spike_cam = get_node_or_null("spike8/Camera2D") as Camera2D
	if spike_cam:
		spike_cam.make_current()

	await get_tree().create_timer(1.5).timeout

	for i in range(1, 17):
		var spike_name = "spike" + str(i)
		var spike = get_node_or_null(spike_name)
		if spike:
			var tween = create_tween()
			tween.tween_property(spike, "scale", Vector2.ZERO, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			tween.tween_callback(Callable(spike, "queue_free"))

	await get_tree().create_timer(1.0).timeout



func _on_lock_end_game() -> void:
	end_game_label.set_position(get_viewport_rect().size / 2 - end_game_label.size / 2)  # Center it
	end_game_label.visible = true  # Corrected typo
	get_tree().paused = true  # Properly pause the game
