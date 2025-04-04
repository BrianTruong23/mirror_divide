extends RigidBody2D

@export var health = 1

func _ready():
	add_to_group("breakable")  # Add to breakable group
	lock_rotation = true

			
func break_box():
	health -= 1
	if health <= 0:
		queue_free()
