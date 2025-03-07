extends CanvasLayer

var heart_initial_pos = 200

signal restart

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is Area2D:
			child.position = Vector2(heart_initial_pos , 50) 
			heart_initial_pos += 100 # Move each Node2D inside the CanvasLayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_enemy_health_deducted() -> void:
	var children = get_children()
	
	if children.size() > 0:
#		Get last children and make it disappear 
		var last_child = children[children.size() - 1]
		last_child.queue_free()
		
		print(children.size())
		
		if children.size() == 1:
			print("Restart! Enemy killed the player")
			emit_signal("restart")
	
