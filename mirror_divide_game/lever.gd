extends CharacterBody2D

signal platform_raised 
@onready var anim = $Area2D/AnimatedSprite2D

func _ready():
	$Area2D.area_entered.connect(_on_area_entered)  # Detects another Area2D

func _on_area_entered(area):
	if area is Area2D:
		platform_raised.emit() 
		anim.play("open")

		
		
		
