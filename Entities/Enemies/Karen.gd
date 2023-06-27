extends "res://Entities/Enemies/civilian.gd"



func _ready():
	evil_action_complete = true
	current_speed = 80

func _process(delta):
	if animation_player.current_animation != "die":
		var distance = Global.pool_center_position - position
		var direction = (distance).normalized()
		if distance.length() >= randi_range(600,500):
			enableBypassBorder()
			velocity.x = direction.x * current_speed
			animation_player.play("karen_run")
		else:
			velocity.x = 0
			animation_player.play("karen_nag")

	move_and_slide()
		
	
