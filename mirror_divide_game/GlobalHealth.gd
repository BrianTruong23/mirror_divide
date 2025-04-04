extends Node

# Health values
var shared_health := 100
var max_health := 100
var heart_value := 20

# UI
var heart_container: HBoxContainer
var full_heart_texture := preload("res://assetss/heart_full.png")
var empty_heart_texture := preload("res://assetss/heart.png")
var heart_ui_scene := preload("res://HeartUI.tscn")

func _ready():
	await get_tree().create_timer(0.1).timeout
	_spawn_heart_ui()
	reset_health()

func reset_health():
	shared_health = max_health
	update_hearts()

func _spawn_heart_ui():
	var existing_ui = get_tree().get_root().find_child("HeartUI", true, false)
	if existing_ui:
		existing_ui.queue_free()

	var ui = heart_ui_scene.instantiate()
	ui.name = "HeartUI"
	get_tree().get_root().add_child(ui)

	heart_container = ui.get_node("HBoxContainer")
	print("HeartUI added to screen")
	print("Hearts found:", heart_container.get_child_count())
	update_hearts()

func apply_damage(damage: int):
	shared_health -= damage
	shared_health = max(shared_health, 0)
	update_hearts()

	if shared_health <= 0:
		reset_health()
		get_tree().reload_current_scene()

func update_hearts():
	if heart_container == null:
		return

	var hearts_to_show = ceil(float(shared_health) / heart_value)
	for i in range(heart_container.get_child_count()):
		var heart = heart_container.get_child(i)
		heart.texture = full_heart_texture if i < hearts_to_show else empty_heart_texture
