extends RigidBody2D

@export var health = 1
var key_scene = preload("res://key.tscn")  # Preload the key scene

func _ready():
	add_to_group("breakable")

func break_box():
	health -= 1
	if health <= 0:
		# Spawn the key at the box's position
		var key = key_scene.instantiate()
		key.position = position
		key.name = "Level1Key"
		get_parent().add_child(key)
		queue_free()  # Remove the box
