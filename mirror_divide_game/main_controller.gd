extends Node

var current_scene_index = 0
var display_time = 3.0  # seconds per scene

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
	current_scene_index = 0
	TransitionManager.play_fade()
	await get_tree().create_timer(1.0).timeout  # Wait 1 second before first scene
	show_next_scene()

func show_next_scene():
	if current_scene_index < scenes.size():
		clear_container_children()
		var next_scene = scenes[current_scene_index].instantiate()
		container.add_child(next_scene)
		print("Showing scene:", current_scene_index)
		current_scene_index += 1
		timer.start(display_time)
	else:
		goto_tutorial()

func _on_timer_timeout():
	if current_scene_index < scenes.size():
		await get_tree().create_timer(1.0).timeout
		show_next_scene()
	else:
		goto_tutorial()


func goto_tutorial():
	TransitionManager.play_fade()
	await get_tree().create_timer(1.0).timeout  # Wait for fade to finish
	get_tree().change_scene_to_file("res://tutorial.tscn")

func clear_container_children():
	for child in container.get_children():
		child.queue_free()
