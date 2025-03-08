extends Area2D

var grabbed_object: Node2D = null
var is_grabbing: bool = false
var grab_offset: Vector2 = Vector2.ZERO  # Offset to maintain relative position
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var player: CharacterBody2D  # Reference to Player2
@export var max_distance: float = 500 # Max distance gun can move from Player2

func _process(delta: float) -> void:
	
	if not player:
		return
		
	var mouse_pos = get_global_mouse_position()
	
	var centroid = player.global_position + Vector2(150, 100)
	
	# Clamp the gun's position within a 300x300 box around the player
	var clamped_x = clamp(mouse_pos.x, centroid.x - max_distance, centroid.x + max_distance)
	var clamped_y = clamp(mouse_pos.y, centroid.y - max_distance, centroid.y + max_distance)

	global_position = Vector2(clamped_x, clamped_y)

	# Move the grabbed object with the hand
	if is_grabbing and grabbed_object:
		move_grabbed_object(grabbed_object)

	if is_grabbing and not grabbed_object:
		check_current_collisions()

func not_move_when_collide_with_walls(area: Area2D):
	if area.is_in_group("walls"):
		return true 
	return false 
		
	
func move_grabbed_object(grabbed_object:Area2D):
	if grabbed_object.is_in_group("grabbable"):
#		The animation happens here 
		grabbed_object.global_position = lerp(grabbed_object.global_position, global_position + grab_offset, 1)  # Instant snap

func check_current_collisions() -> void:
	var overlapping_areas = get_overlapping_areas()
	for area in overlapping_areas:
		move_grabbed_object(area)
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("grab"):
		is_grabbing = true
		animated_sprite.play('grab')
	elif event.is_action_released("grab"):
		is_grabbing = false
		grabbed_object = null  # Release the object when letting go
		animated_sprite.play('release')

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
