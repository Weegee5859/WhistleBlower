extends "res://Entities/Enemies/civilian.gd"

@onready var running_speed: int = randi_range(280,350)

func _ready():
	current_speed = running_speed
	
func _process(delta):
	# walk towards the right at current_speed
	velocity.x = current_speed
	deleteWhenFarAway()
	move_and_slide()
	
