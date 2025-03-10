extends CharacterBody2D

@onready var anim = $AnimatedSprite2D      
@onready var anim_level_1 = $Area2D/AnimatedSprite2D
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

func _on_combo_lock_door_unlocked() -> void:
	open_door() # Replace with function body.

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		if body.has_key == true:
			anim_level_1.play('open')
			set_deferred("collision_layer", 0)
			set_deferred("collision_mask", 0)
