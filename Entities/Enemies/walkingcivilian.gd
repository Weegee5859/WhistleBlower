extends "res://Entities/Enemies/civilian.gd"
@onready var walking_speed: int = randi_range(100,110)

func _ready():
	current_speed = walking_speed
	
func _process(delta):
	if ready_to_leave:
		leave()
	else:
		# walk towards the right at current_speed
		velocity.x = current_speed
	deleteWhenFarAway()
	move_and_slide()
