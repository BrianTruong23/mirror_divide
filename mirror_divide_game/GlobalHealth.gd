extends Node

# Health values
var shared_health := 100
var max_health := 100
var heart_value := 20

# UI
var heart_container: HBoxContainer
var full_heart_texture := preload("res://assetss/heart_full.png")
var half_heart_texture := preload("res://assetss/heart_half.png")
var empty_heart_texture := preload("res://assetss/heart.png")
var orange_full_heart_texture := preload("res://assetss/orange_heart_full.png")
var orange_half_heart_texture := preload("res://assetss/orange_heart_half.png")
var heart_ui_scene := preload("res://HeartUI.tscn")

var show_hearts := true
var is_final_level := false

func _ready():
	await get_tree().create_timer(0.1).timeout
	_spawn_heart_ui()
	reset_health()
	if get_tree().current_scene.name == "title":
		heart_container.get_parent().visible = false 

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
	update_hearts()

func apply_damage(damage: int):
	shared_health -= damage
	shared_health = max(shared_health, 0)
	update_hearts()

	if shared_health <= 0:
		reset_health()
		get_tree().reload_current_scene()

func update_hearts():
	if heart_container == null or not show_hearts:
		return

	var total_hearts = ceil(float(max_health) / heart_value)
	var filled_hearts = int(shared_health / heart_value)
	var has_half = (shared_health % heart_value) >= (heart_value / 2)

	for i in range(heart_container.get_child_count()):
		var heart = heart_container.get_child(i)

		if i < filled_hearts:
			heart.texture = orange_full_heart_texture if is_final_level else full_heart_texture
		elif i == filled_hearts and has_half:
			heart.texture = orange_half_heart_texture if is_final_level else half_heart_texture
		else:
			heart.texture = empty_heart_texture
