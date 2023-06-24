extends "res://Entities/entity.gd"
@export var doing_evil_action: bool = false
@export var evil_action_complete: bool = false
@onready var got_caught_movement_speed: int = 0
@onready var sad_movement_speed: int = 50
@export var default_speed: int = 10
@export var current_speed: int
@onready var mouse_area_2d = $MouseArea2D
@onready var collision = $CollisionShape2D
@onready var scoreWhenCaught: int = 10
@onready var scoreWhenWrong: int = 5
@onready var scoreWhenEvilEscaped: int = 10
@onready var scoreWhenEvilIsDone: int = 15
@onready var scoreWhenInnocentLeftHappy: int = 5
@onready var ready_to_leave: bool
@onready var sad: bool


func _ready():
	pass

func _input(event):
	# If you left a civilian do something...
	if Input.is_action_just_pressed("left_click") and mouse_colliding:
		# left_clicked or blew whistle at someone doing an evil action
		if doing_evil_action:
			current_speed=got_caught_movement_speed
			queue_free()
			print(str(self) + " got caught!")
			Global.scoreboard.addPoints(scoreWhenCaught)
		else:
			# left_clicked or blew whistle at innocent person
			current_speed=sad_movement_speed
			Global.scoreboard.removePoints(scoreWhenWrong)
			sad = true
			ready_to_leave = true
			print(str(self) + " was innocent! :(")

func _process(delta):
	move_and_slide()
	
func deleteWhenFarAway():
	var distance = Global.pool_center_position - position
	
	if distance.length() >= 800:
		queue_free()
		if doing_evil_action or evil_action_complete:
			print(str(self) + " left the pool after doing EVVVVILLL!")
			Global.scoreboard.removePoints(scoreWhenEvilEscaped)
			return
		if sad:
			print(str(self) + " left the pool sad! :(")
			return
		print(str(self) + " left the pool happy!")
		Global.scoreboard.addPoints(scoreWhenInnocentLeftHappy)

func enableBypassBorder():
	collision.disabled = true

func disableBypassBorder():
	collision.disabled = false

func canBypassBorder():
	return collision.disabled
	
func leave():
	enableBypassBorder()
	var direction = (position - Global.pool_center_position).normalized()
	velocity = direction*current_speed
