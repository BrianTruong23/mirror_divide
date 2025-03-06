extends CharacterBody2D

@onready var anim = $AnimatedSprite2D      
@onready var door_camera = $Camera2D         
@onready var collision = $CollisionShape2D  

func open_door():
	door_camera.make_current()  # Activate camera transition
	var tween = get_tree().create_tween()
	tween.tween_property(door_camera, "zoom", Vector2(1, 1), 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	anim.play("open")  # Play door opening animation

	# Disable collision by removing from collision layers and masks
	set_deferred("collision_layer", 0)
	set_deferred("collision_mask", 0)

	await tween.finished
	door_camera.enabled = false  # Optionally, switch back after transition


func _on_lever_2_lever_activated() -> void:
	open_door()
