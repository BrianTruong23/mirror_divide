extends Node

var current_scene_index = 0
var display_time = 2.0  # seconds per scene

var scenes = [
	preload("res://Scene/Scene1.tscn"),
	preload("res://Scene/Scene2.tscn"),
	preload("res://Scene/Scene3.tscn"),
	preload("res://Scene/Scene4.tscn"),
]

var timer: Timer
var container: Node
var start_button: TextureButton
var click_sound: AudioStreamPlayer2D

func _ready():
	timer = get_node("Timer")
	container = get_node("SceneContainer")
	start_button = get_node("startButton")
	click_sound = start_button.get_node("ClickSound")

	start_button.pressed.connect(_on_start_button_pressed)
	timer.timeout.connect(_on_timer_timeout)

func _on_start_button_pressed():
	click_sound.play()
	start_button.hide()
	start_game()

func start_game():
	show_next_scene()
	TransitionManager.play_fade()

func show_next_scene():
	if current_scene_index < scenes.size():
		print("Showing scene:", current_scene_index)
		clear_container_children()
		var next_scene = scenes[current_scene_index].instantiate()
		container.add_child(next_scene)
		current_scene_index += 1
		timer.start(display_time)
	else:
		goto_tutorial()

func _on_timer_timeout():
	show_next_scene()

func goto_tutorial():
	get_tree().change_scene_to_file("res://tutorial.tscn")

func clear_container_children():
	for child in container.get_children():
		child.queue_free()
