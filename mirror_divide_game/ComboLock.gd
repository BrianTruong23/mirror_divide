extends Node2D

@onready var label1 = $DigitContainer/Digit1/Label1
@onready var label2 = $DigitContainer/Digit2/Label2
@onready var label3 = $DigitContainer/Digit3/Label3

signal door_unlocked  # Define the signal

# The correct combination
var correct_code = [3, 2, 2]  # Change this to your desired combo

# Current entered combination
var entered_code = [0, 0, 0]

func _ready():
	update_labels()

# Function to update label values
func update_labels():
	label1.text = str(entered_code[0])
	label2.text = str(entered_code[1])
	label3.text = str(entered_code[2])

# Increase digit (ensures max of 9)
func increase_digit(index):
	entered_code[index] = min(entered_code[index] + 1, 9)  # Stops at 9
	update_labels()

# Decrease digit (ensures min of 0)
func decrease_digit(index):
	entered_code[index] = max(entered_code[index] - 1, 0)  # Stops at 0
	update_labels()

# Function to check if the combination is correct
func check_combination():
	if entered_code == correct_code:
		print("Combo correct! Door unlocked.")
		unlock_door()
	else:
		print("Wrong combo!")

# Unlock door function
func unlock_door():
	print("Door opens!") 
	door_unlocked.emit()

func _on_check_button_pressed():
	check_combination()

func _on_up_button_2_pressed() -> void:
	increase_digit(1) # Replace with function body.

func _on_up_button_1_pressed() -> void:
	increase_digit(0) # Replace with function body.


func _on_down_button_1_pressed() -> void:
	decrease_digit(0) # Replace with function body.


func _on_down_button_2_pressed() -> void:
	decrease_digit(1) # Replace with function body.


func _on_up_button_3_pressed() -> void:
	increase_digit(2) # Replace with function body.


func _on_down_button_3_pressed() -> void:
	decrease_digit(2) # Replace with function body.
