extends Node2D

# Preload different mob types
@export var mob_type_a: PackedScene
@export var mob_type_b: PackedScene
@export var mob_type_c: PackedScene

var spawn_list = []  # Define as empty first

func _ready():
	# ✅ Initialize the spawn list inside _ready()
	spawn_list = [
		{ "scene": mob_type_a, "count": 3 },
		{ "scene": mob_type_b, "count": 1 },
		{ "scene": mob_type_c, "count": 5 }
	]

	# ✅ Ensure all mob scenes are assigned before spawning
	for spawn_data in spawn_list:
		if spawn_data["scene"] == null:
			print("Error: One of the mob scenes is not assigned!")
			return  # Stop execution to avoid crashing

	spawn_mobs()

func spawn_mobs():
	for spawn_data in spawn_list:
		var mob_scene = spawn_data["scene"]
		var count = spawn_data["count"]

		for i in range(count):
			if mob_scene:
				var mob_instance = mob_scene.instantiate()
				add_child(mob_instance)  # Spawn inside MobSpawner
				mob_instance.position = get_random_spawn_position()  # Set random spawn position
			else:
				print("Error: One of the mob scenes is still not assigned!")

func get_random_spawn_position() -> Vector2:
	var spawn_area_size = Vector2(200, 200)  # Adjust as needed
	var offset = Vector2(randf_range(-spawn_area_size.x, spawn_area_size.x), randf_range(-spawn_area_size.y, spawn_area_size.y))
	return global_position + offset  # Spawn relative to MobSpawner
