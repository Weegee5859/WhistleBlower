extends "res://Entities/Enemies/civilian.gd"
@onready var walking_speed: int = randi_range(100,110)

func _ready():
	doing_evil_action = false
	evil_action_complete = false
	current_speed = walking_speed
	selectRandomTextureVariant()
	
func _process(delta):
	if ready_to_leave:
		leave()
	else:
		# walk towards the right at current_speed
		animation_player.play("run")
		velocity.x = current_speed
	deleteWhenFarAway()
	flipSprite()
	move_and_slide()
