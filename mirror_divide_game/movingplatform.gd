extends StaticBody2D

var original_position = Vector2.ZERO
var target_position = Vector2.ZERO
var speed = 100.0
var is_rising = false

func _ready():
	original_position = position
	target_position = original_position + Vector2(0, -125)

func _process(delta):
	if is_rising:
		position = position.move_toward(target_position, speed * delta)
		if position == target_position:
			is_rising = false

func rise():
	is_rising = true
