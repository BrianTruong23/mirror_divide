extends RigidBody2D

@export var health = 1

func _ready():
	add_to_group("breakable")  # Add box to "breakable" group

func break_box():
	queue_free()  # Break the box
