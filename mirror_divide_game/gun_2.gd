extends Area2D

var grabbed_object: Node2D = null
var is_grabbing: bool = false
var grab_offset: Vector2 = Vector2.ZERO  # Offset to maintain relative position

func _process(delta: float) -> void:
	var vel: Vector2 = get_global_mouse_position() - global_position
	position += vel * delta * 20  # Smooth movement
	
	print(is_grabbing)
	print(grabbed_object)
	# Move the grabbed object with the hand
	if is_grabbing and grabbed_object:
		grabbed_object.global_position = lerp(grabbed_object.global_position, global_position + grab_offset, 1)  # Instant snap

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


#
#extends Area2D
#
##  the hand moves around 
##  when grab area signal from the keyboard activated, it changed animation and it grabs the object (make the object move with the hand)
#
#var grabbed_object: Node2D = null
#var is_grabbing: bool = false
#
#func _process(delta: float) -> void:
#
	#var vel: Vector2 = get_global_mouse_position() - global_position
	#
	#position += vel * delta * 10
	#
	#if is_grabbing and grabbed_object:
		#grabbed_object.global_position = global_position
	#
	#
	#
#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("player_grab_2"):
		#is_grabbing = true
	#elif event.is_action_released("player_grab_2"):
		#is_grabbing = false
#
		#
#func _on_area_entered(area: Area2D) -> void:
	#print("area entered: ", area)
	#if is_grabbing and not grabbed_object: 
		#grabbed_object = area 
#
#
#func _on_area_exited(area: Area2D) -> void:
	#print("area exited: ", area)
	#if grabbed_object == area: 
		#grabbed_object = null

#extends Area2D
#
#@export var offset_x: float = 50.0  # Adjust distance from player's center
#@export var grapple_speed: float = 600.0  # Speed at which the grapple extends
#@export var retract_speed: float = 500.0  # Speed at which the object is pulled in
#@export var max_distance: float = 500.0  # Maximum grappling distance
#
#@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D  # Reference to gun sprite
#@onready var raycast: RayCast2D = $RayCast2D  # Raycast to detect grabbable objects
#@onready var grapple_line: Node2D = $GrappleLine  # The expanding visual line for the grapple
#
#var is_grappling: bool = false  # Tracks whether grapple is extending
#var hit_object: Node = null  # Stores the object hit by the grapple
#var grapple_direction: Vector2  # Direction the grapple extends
#
#func _ready() -> void:
	## Ensure `grapple_line` and `raycast` exist before using them
	#if has_node("GrappleLine"):
		#grapple_line = $GrappleLine
	#else:
		#print("Error: GrappleLine node is missing from Gun_2!")
#
	#if has_node("RayCast2D"):
		#raycast = $RayCast2D
	#else:
		#print("Error: RayCast2D node is missing from Gun_2!")
#
#func _process(delta: float) -> void:
	#var mouse_pos = get_global_mouse_position()
#
	## Keep Gun 2 positioned on Player 2's left side
	#position.x = offset_x  
#
	## Invert rotation to fix flipped aiming
	#rotation = (mouse_pos - global_position).angle() + PI  # Add PI to correct inversion
#
	## If right-click is held, start extending the grapple
	#if Input.is_action_just_pressed("player_grab_2") and not is_grappling:
		#start_grapple(mouse_pos, delta)
#
	## If right-click is released, retract
	#if Input.is_action_just_released("player_grab_2"):
		#reset_grapple()
#
	## If grappling, extend it
	#if is_grappling:
		#extend_grapple(delta)
#
	## If a hit object exists, pull it toward the player
	#if hit_object:
		#pull_object(delta)
#
#func start_grapple(target_pos: Vector2, delta: float):
	#is_grappling = true
	#grapple_direction = (target_pos - global_position).normalized()
	#sprite.play("grab")  # Play grab animation
	#grapple_line.scale.y = 1  # Reset grapple length
#
	#extend_grapple(delta)  # Ensure delta is used when extending
#
#func extend_grapple(delta: float):
	#if not is_grappling or grapple_line == null or raycast == null:
		#return
#
	## Extend the grappling line
	#grapple_line.scale.y += grapple_speed * delta / 100.0
#
	## Move the RayCast2D forward to detect objects
	#if raycast != null:
		#raycast.target_position = grapple_direction * grapple_line.scale.y * 100
#
		## Check if RayCast2D collides with something grabbable
		#if raycast.is_colliding():
			#var collider = raycast.get_collider()
			#print("RayCast hit:", collider.name)  # Debugging message
#
			#if collider != null and collider.has_method("grabbed"):
				#hit_object = collider
				#hit_object.grabbed(self.get_parent(), self)  # Pass both player and grappling hook reference
				#is_grappling = false  # Stop extending
				#print("Hit object and grabbed:", collider.name)
#
#func pull_object(delta: float):
	#if not hit_object:
		#return
#
	## Move the object TOWARD the player
	#var move_direction = (global_position - hit_object.global_position).normalized()
	#hit_object.global_position -= move_direction * retract_speed * delta  # Reversed movement
#
	## If object reaches player, release grapple
	#if hit_object.global_position.distance_to(global_position) < 10:
		#reset_grapple()
#
#func reset_grapple():
	#is_grappling = false
	#hit_object = null
	#grapple_line.scale.y = 1  # Reset grapple size
#
	## Ensure `raycast` exists before modifying `target_position`
	#if raycast != null:
		#raycast.target_position = Vector2.ZERO  # Reset RayCast2D
#
	#sprite.play("default")  # Switch back to idle animation
