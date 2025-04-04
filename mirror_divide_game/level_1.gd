extends Node2D

var reset_held_time = 0.0
var reset_threshold = 1.0  # Hold for 1 second to reset
@onready var canvas_layer_key = $CanvasLayerKey/Sprite2D
@onready var canvas_layer_label = $CanvasLayerKey/Label
@onready var end_game_label = $CanvasLayer/EndGameLabel

signal key_acquired_signal

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
 
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
