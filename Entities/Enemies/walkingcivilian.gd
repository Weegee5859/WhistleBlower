extends "res://Entities/Enemies/civilian.gd"
@onready var walking_speed: int = randi_range(25,35)

func _ready():
	current_speed = walking_speed
	
func _process(delta):
	# walk towards the right at current_speed
	velocity.x = current_speed
	move_and_slide()
