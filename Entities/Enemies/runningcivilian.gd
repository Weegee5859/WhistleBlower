extends "res://Entities/Enemies/civilian.gd"

@onready var running_speed: int = randi_range(280,350)

func _ready():
	doing_evil_action = true
	current_speed = running_speed
	selectRandomTextureVariant()
	
func _process(delta):
	if not animation_player.is_playing():
		animation_player.play("run")
	# walk towards the right at current_speed
	if not caught:
		velocity.x = current_speed
	else:
		velocity = Vector2(0,0)
	deleteWhenFarAway()
	flipSprite()
	move_and_slide()
	
