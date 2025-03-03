extends StaticBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var platform = get_node("/root/Game/movingplatform")
var is_pressed = false

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
	activate_platform()

func activate_platform():
	if platform and platform.has_method("rise"):
		platform.call("rise")
		print("Platform rise called")  # Confirm this runs
	else:
		print("Platform not found or no rise method: ", platform)
