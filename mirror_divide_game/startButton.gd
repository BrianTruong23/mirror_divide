extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	# Preload the new scene as a PackedScene
	#var tutorial_scene = preload("res://tutorial.tscn")
	# Instantiate the PackedScene to get a Node
	#var new_scene = tutorial_scene.instantiate()
	
	# Get the SceneTree and root node
	#var tree = get_tree()
	#var root = tree.root
	
	# Optionally, remove the current scene if it exists
	#if tree.current_scene:
	#	tree.current_scene.queue_free()
	
	# Add the new scene as a child of the root node
	#root.add_child(new_scene)
	
	# Update the current_scene property
	#tree.current_scene = new_scene
	pass
