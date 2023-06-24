extends "res://Entities/entity.gd"

func _ready():
	velocity.x=5

func _input(event):
	if Input.is_action_just_pressed("left_click") and mouse_colliding:
		velocity.x=1

func _process(delta):
	move_and_slide()
