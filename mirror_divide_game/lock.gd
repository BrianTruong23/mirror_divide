extends CharacterBody2D

signal end_game 

@onready var anim = $lock/Area2D/AnimatedSprite2D

func _on_area_2d_body_entered(body) -> void:
	print(body)
	if body.is_in_group('player'):
		if body.has_key == true:
			#anim.play('open')
			print("it is good")
			set_deferred("collision_layer", 0)
			set_deferred("collision_mask", 0)
			emit_signal("end_game")
			
			
