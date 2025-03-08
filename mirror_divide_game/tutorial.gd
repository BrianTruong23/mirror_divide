extends Node2D

@onready var restart_label = $RestartLabel
@onready var instruction_canvas = $InstructionCanvasLayer

var instruction_3_visible = false 
var instruction2_visible = true  

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Optionally hide the label initially
	restart_label.visible = false
	
	display_canvas_layer()
	
	for i in range(2, 6):  # This will iterate from 2 to 6
		var instruction_node = $Control.get_node("instruction" + str(i))
		if instruction_node:
			instruction_node.visible = false
	

func display_instruction(instruction: Label, position: Vector2):

	# Make the label visible
	instruction.visible = true
	instruction.position = position
	
func display_instruction_top_right(instruction: Label):
		# Get the viewport size
	var viewport_size = get_viewport_rect().size

	# Position at top right, accounting for the label's size
	# to keep it fully visible within the screen
	instruction.position = Vector2(
		viewport_size.x - instruction.size.x - 20,  # 20 pixels padding from right edge
		20  # 20 pixels padding from top edge
	)

	instruction.visible = true
	print("Label positioned at:", instruction.position)

	
func display_canvas_layer():
	var container = instruction_canvas.get_node("Control")
	
	if container is Control:
		container.position = get_viewport_rect().size / 2 - container.size / 2 - Vector2(300, 200)
	
	# Make the canvas layer visible
	instruction_canvas.visible = true
	
	# Create timer for hiding
	var timer = get_tree().create_timer(4.0)
	
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))

func _on_timer_timeout():
	instruction_canvas.visible = false

func _input(event):
	
	if Input.is_action_just_pressed("pull_up_panel"):
		instruction_canvas.visible = !instruction_canvas.visible
	
	if Input.is_action_just_pressed("camera_switch"):
		$Control/instruction1.visible = false 
		
		if instruction2_visible == true: 
			display_instruction_top_right($Control/instruction2)
			instruction2_visible = false 
		
		if instruction_3_visible == true:
			$Control/instruction3.visible = false 
			$Control/instruction4.visible = true 
		
	
	
		
func _on_canvas_layer_restart() -> void:
	# Set restart label to the center of the screen
	restart_label.global_position = (Vector2(get_viewport().size) + Vector2(100,0)) / 2
	# Make the label visible
	restart_label.visible = true
	
	# Pause the game
	get_tree().paused = true
	
	# Make sure the restart label still processes while paused
	restart_label.process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Force UI update BEFORE waiting
	await get_tree().process_frame
	
	# Create a timer that works in paused state
	var timer = get_tree().create_timer(2.0, true)
	await timer.timeout
	
	# Unpause before restarting
	get_tree().paused = false
	
	# Restart the game by reloading the current scene
	get_tree().reload_current_scene()


func _on_lever_2_lever_activated() -> void:
	print("Lever Activated")
	$Control/instruction2.visible = false 
	display_instruction_top_right($Control/instruction3)
	$Control/instruction3.visible = true 
	instruction_3_visible = true 


func _on_lever_platform_raised() -> void:
	$Control/instruction4.visible = false 
	display_instruction_top_right($Control/instruction5)

	
