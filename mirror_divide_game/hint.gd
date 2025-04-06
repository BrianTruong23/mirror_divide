extends TextureButton

@export var hint_text: String = "Hint"

# Cache the Label node (assuming it’s a direct child named "Label")
@onready var hint_label: Label = $Label

func _ready():
	hint_label.visible = false  # Ensure it's hidden initially
	hint_label.text = hint_text # Set the label text from the exported variable

func _on_mouse_entered():
	print("Mouse entered")
	hint_label.visible = true # Replace with function body.

func _on_mouse_exited():
	print("Mouse exited")
	hint_label.visible = false # Replace with function body.
