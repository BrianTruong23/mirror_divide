extends StaticBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var platform = get_node("/root/Game/movingplatform")
var is_pressed = false

var enemy_scene = preload("res://Enemy.tscn")

func _ready():
	animated_sprite.play("unpressed")
	print("Button ready, platform: ", platform)  # Check if platform is found

func _on_detection_area_area_entered(area):
	if area.is_in_group("projectiles") and not is_pressed:
		press_button()
		area.queue_free()

func press_button():
	is_pressed = true
	animated_sprite.play("pressed")
	#activate_platform()
	spawn_mobs()
	await get_tree().create_timer(8.0).timeout
	unpress_button()
	
func unpress_button():
	is_pressed = false
	animated_sprite.play("unpressed")
	print("Button unpressed after 10 seconds")

#func activate_platform():
	#if platform and platform.has_method("rise"):
		#platform.call("rise")
		#print("Platform rise called")  # Confirm this runs
	#else:
		#print("Platform not found or no rise method: ", platform)

func spawn_mobs():
	# Spawn 3 large enemies (scale 1.5x)
	for i in range(3):
		var large_enemy = enemy_scene.instantiate()
		large_enemy.scale = Vector2(1.5, 1.5)  # Large size
		large_enemy.position = position + Vector2(-500 + i * 80, -50)  # Adjusted spacing
		get_parent().add_child(large_enemy)

	# Spawn 2 medium enemies (default scale 1x)
	for i in range(2):
		var medium_enemy = enemy_scene.instantiate()
		medium_enemy.scale = Vector2(1.0, 1.0)  # Medium size (default)
		medium_enemy.position = position + Vector2(-500 + i * 60, -100)
		get_parent().add_child(medium_enemy)

	# Spawn 2 small enemies (scale 0.5x)
	for i in range(2):
		var small_enemy = enemy_scene.instantiate()
		small_enemy.scale = Vector2(0.5, 0.5)  # Small size
		small_enemy.position = position + Vector2(-500 + i * 40, -150)
		get_parent().add_child(small_enemy)
