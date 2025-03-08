extends Area2D

var grabbed_object: RigidBody2D = null
var is_grabbing: bool = false
var grab_offset: Vector2 = Vector2.ZERO  # Offset to maintain relative position
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var player: CharacterBody2D  # Reference to Player
@export var max_distance: float = 350 # Max distance hand can move from Player

func _process(delta: float) -> void:
	if not player:
		return

	var mouse_pos = get_global_mouse_position()
	var centroid = player.global_position + Vector2(150, 100)
	
	# Clamp position within a 300x300 box around the player
	global_position.x = clamp(mouse_pos.x, centroid.x - max_distance, centroid.x + max_distance)
	global_position.y = clamp(mouse_pos.y, centroid.y - max_distance, centroid.y + max_distance)

	# Move the grabbed object with the hand
	if is_grabbing and grabbed_object:
		move_grabbed_object(grabbed_object)

func move_grabbed_object(grabbed_object: Node) -> void:
	var target = grabbed_object
	if grabbed_object is Area2D and grabbed_object.get_parent() is CharacterBody2D:
		target = grabbed_object.get_parent()
	
	target.global_position = lerp(target.global_position, global_position + grab_offset, 1)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("grab"):
		is_grabbing = true
		animated_sprite.play('grab')
	elif event.is_action_released("grab"):
		is_grabbing = false
		release_grabbed_object(grabbed_object)
		animated_sprite.play('release')

func release_grabbed_object(grabbed_object) -> void:
	if grabbed_object:
		grabbed_object.freeze = false  # Unfreeze physics simulation
		grabbed_object.gravity_scale = 1.0
		grabbed_object.sleeping = false
		grabbed_object = null  # Release reference
	
func _on_area_entered(area: Area2D) -> void:
	if not grabbed_object:
		var parent = area.get_parent()
		if parent is RigidBody2D:
			grabbed_object = parent
			grabbed_object.freeze = true  # Stop physics simulation while holding
			grab_offset = grabbed_object.global_position - global_position

func _on_area_exited(area: Area2D) -> void:
	if grabbed_object and area.get_parent() == grabbed_object:
		grabbed_object = null
