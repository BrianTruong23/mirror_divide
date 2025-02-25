extends Area2D

var grabbed_object: Node2D = null
var is_grabbing: bool = false
var grab_offset: Vector2 = Vector2.ZERO  # Offset to maintain relative position

func _process(delta: float) -> void:
	var vel: Vector2 = get_global_mouse_position() - global_position
	position += vel * delta * 20  # Smooth movement
	
	# Move the grabbed object with the hand
	if is_grabbing and grabbed_object:
		move_grabbed_object(grabbed_object)
		# Detect areas that the object is currently colliding with

	if is_grabbing and not grabbed_object:
		check_current_collisions()


func move_grabbed_object(grabbed_object:Area2D):
	grabbed_object.global_position = lerp(grabbed_object.global_position, global_position + grab_offset, 1)  # Instant snap


func check_current_collisions() -> void:
	var overlapping_areas = get_overlapping_areas()
	for area in overlapping_areas:
		move_grabbed_object(area)

		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("grab"):
		is_grabbing = true
	elif event.is_action_released("grab"):
		is_grabbing = false
		grabbed_object = null  # Release the object when letting go

func _on_area_entered(area: Area2D) -> void:
	print("area_entered", is_grabbing)
	print("area entered: ", area)
	if is_grabbing and not grabbed_object:
		grabbed_object = area  # Assign the grabbed object

func _on_area_exited(area: Area2D) -> void:
	print("area_exited", is_grabbing)
	print("area exited: ", area)
	if grabbed_object == area:
		grabbed_object = null  # Release the object
