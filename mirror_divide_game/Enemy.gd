extends CharacterBody2D

@export var base_speed := 100.0
@export var speed_variation := 50.0
@export var jump_strength := -400.0
@export var jump_variation := 200.0
@export var small_damage := 5  # 20 hits to kill (100 / 5)
@export var medium_damage := 10  # 10 hits to kill (100 / 10)
@export var large_damage := 20  # 5 hits to kill (100 / 20)
@export var max_health := 100

const GRAVITY = 1000.0

var current_health := max_health
var attack_damage: int  # This will be set based on size
var direction := Vector2.ZERO
var current_speed := 0.0
var rng = RandomNumberGenerator.new()
var movement_timer: Timer
var erratic_timer: Timer
var direction_change_timer: Timer
var sprite: AnimatedSprite2D
var is_erratic := false

func _ready():
	add_to_group("enemies")
	rng.randomize()
	determine_damage()
	
	# Set up sprite reference
	sprite = $AnimatedSprite2D if has_node("AnimatedSprite2D") else null
	
	# Create and configure timers if they don't exist
	setup_timer("MovementTimer", "_on_movement_timer_timeout", 1.0, 3.0)
	setup_timer("ErraticTimer", "_on_erratic_timer_timeout", 5.0, 15.0)
	setup_timer("DirectionChangeTimer", "_on_direction_change_timer_timeout", 0.2, 1.5)
	
	# Initial direction and speed
	change_direction()
	update_speed()

# Create and set up a timer if it doesn't exist
func setup_timer(timer_name: String, callback_method: String, min_time: float, max_time: float) -> void:
	# Check if timer already exists
	if has_node(timer_name):
		var existing_timer = get_node(timer_name)
		if callback_method == "_on_movement_timer_timeout":
			movement_timer = existing_timer
			movement_timer.timeout.connect(_on_movement_timer_timeout)
		elif callback_method == "_on_erratic_timer_timeout":
			erratic_timer = existing_timer
			erratic_timer.timeout.connect(_on_erratic_timer_timeout)
		elif callback_method == "_on_direction_change_timer_timeout":
			direction_change_timer = existing_timer
			direction_change_timer.timeout.connect(_on_direction_change_timer_timeout)
	else:
		# Create new timer
		var new_timer = Timer.new()
		new_timer.name = timer_name
		new_timer.one_shot = false
		new_timer.wait_time = rng.randf_range(min_time, max_time)
		new_timer.autostart = true
		add_child(new_timer)
		
		# Connect signal based on the timer type
		if callback_method == "_on_movement_timer_timeout":
			movement_timer = new_timer
			movement_timer.timeout.connect(_on_movement_timer_timeout)
		elif callback_method == "_on_erratic_timer_timeout":
			erratic_timer = new_timer
			erratic_timer.timeout.connect(_on_erratic_timer_timeout)
		elif callback_method == "_on_direction_change_timer_timeout":
			direction_change_timer = new_timer
			direction_change_timer.timeout.connect(_on_direction_change_timer_timeout)

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	# Random chance to change direction while moving (more frequent in erratic mode)
	var change_chance = 0.005 if not is_erratic else 0.02
	if rng.randf() < change_chance:
		change_direction()
	
	# Random chance to jump while moving
	var jump_chance = 0.002 if not is_erratic else 0.01
	if is_on_floor() and rng.randf() < jump_chance:
		perform_jump()
	
	# Apply current movement
	velocity.x = direction.x * current_speed
	
	# Move the character
	move_and_slide()
	
	# Change direction upon collision with a wall
	if is_on_wall():
		direction.x *= -1
		update_sprite_direction()
		
		# Wall bounces might trigger speed changes
		if rng.randf() < 0.3:
			update_speed()

func change_direction():
	# Choose random direction (left, right, or brief pause)
	var choices = [-1, 1]
	
	# In normal mode, occasionally pause (direction.x = 0)
	if not is_erratic and rng.randf() < 0.15:
		direction.x = 0
		# Short pause then resume movement
		await get_tree().create_timer(rng.randf_range(0.1, 0.5)).timeout
		direction.x = choices[rng.randi() % choices.size()]
	else:
		direction.x = choices[rng.randi() % choices.size()]
	
	update_sprite_direction()
	
	# Random chance to update speed when changing direction
	if rng.randf() < 0.7:
		update_speed()

func update_speed():
	# Calculate a random speed
	var speed_factor = 1.0
	if is_erratic:
		speed_factor = rng.randf_range(0.8, 2.0)  # Much more speed variation in erratic mode
	else:
		speed_factor = rng.randf_range(0.7, 1.3)
	
	current_speed = base_speed + rng.randf_range(-speed_variation, speed_variation)
	current_speed *= speed_factor

func perform_jump():
	# Random jump height
	var jump_power = jump_strength
	
	# In erratic mode, jumps can be much higher or lower
	if is_erratic:
		jump_power = jump_strength + rng.randf_range(-jump_variation, -jump_variation/2)
	else:
		jump_power = jump_strength + rng.randf_range(-jump_variation/2, jump_variation/2)
	
	velocity.y = jump_power

func update_sprite_direction():
	if sprite and direction.x != 0:  # Don't flip if paused
		sprite.flip_h = direction.x < 0

func _on_movement_timer_timeout():
	# This timer controls regular direction changes
	if rng.randf() < 0.6:  # 60% chance to change direction
		change_direction()
	
	# Set new random timer
	movement_timer.wait_time = rng.randf_range(0.8, 3.0)
	movement_timer.start()

func _on_erratic_timer_timeout():
	# Toggle erratic mode
	is_erratic = !is_erratic
	
	if is_erratic:
		# Shorter erratic periods (1-3 seconds)
		erratic_timer.wait_time = rng.randf_range(1.0, 3.0)
	else:
		# Longer normal periods (4-12 seconds)
		erratic_timer.wait_time = rng.randf_range(4.0, 12.0)
	
	erratic_timer.start()

func _on_direction_change_timer_timeout():
	# Small random chance of sudden direction change
	var change_probability = 0.2 if not is_erratic else 0.4
	if rng.randf() < change_probability:
		change_direction()
	
	# Reset timer with varying frequency
	var min_time = 0.1 if is_erratic else 0.3
	var max_time = 0.8 if is_erratic else 1.5
	direction_change_timer.wait_time = rng.randf_range(min_time, max_time)
	direction_change_timer.start()

func die():
	queue_free()

func determine_damage():
	if scale.x <= 0.75:
		attack_damage = small_damage
		max_health = 50
	elif scale.x <= 1.25:
		attack_damage = medium_damage
		max_health = 100
	else:
		attack_damage = large_damage
		max_health = 150
	
	current_health = max_health

func take_damage(amount: int):
	current_health -= amount
	if current_health <= 0:
		die()

func _on_damage_area_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player"):
		print("Dealing", attack_damage, "damage to", body.name)
		body.take_damage(attack_damage)
