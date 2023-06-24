extends "res://Entities/entity.gd"
@export var doing_evil_action: bool = false
@export var evil_action_complete: bool = false
@onready var got_caught_movement_speed: int = 0
@onready var sad_movement_speed: int = 25
@export var default_speed: int = 10
@export var current_speed: int
@onready var mouse_area_2d = $MouseArea2D

func _ready():
	pass

func _input(event):
	# If you left a civilian do something...
	if Input.is_action_just_pressed("left_click") and mouse_colliding:
		# left_clicked or blew whistle at someone doing an evil action
		if doing_evil_action:
			print("GOT EMMM")
			current_speed=got_caught_movement_speed
		else:
			# left_clicked or blew whistle at innocent person
			print("he aint do nothin :(")
			current_speed=sad_movement_speed

func _process(delta):
	move_and_slide()
