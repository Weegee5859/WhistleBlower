extends "res://Entities/Enemies/civilian.gd"
@onready var idle_timer = $IdleTimer
@onready var wandering_timer = $WanderingTimer
@onready var ready_to_wander: bool
@export var walking_speed: int = 150
@onready var distance: Vector2 = Vector2(0,0)
@onready var direction: Vector2 = Vector2(0,0)
@onready var ready_to_leave_timer = $ReadyToLeaveTimer

@onready var swimming: bool 
@onready var swim_speed: int = 75

@onready var diver: bool

@onready var sick: bool
@onready var ready_to_poop_timer = $ReadyToPoopTimer

#State Machine
enum states {enter_scene,idle,wander,dive,sick,leave_scene}
@onready var current_state = states.enter_scene
@onready var state_change_timer = $StateChangeTimer

#Dialog
@onready var dialog_box = $DialogBox

#State Machine func
func changeState(new_state: states):
	state_change_timer.stop()
	exitState(current_state)
	current_state = new_state
	enterState(new_state)
	
func enterState(state):
	# Runs when changed to this state
	if state == states.wander:
		# Set Random Direction
		direction = Vector2(randf_range(-1,1),randf_range(-1,1))
		state_change_timer.wait_time = randi_range(2,3)
		state_change_timer.start()
	if state == states.idle:
		velocity = Vector2(0,0)
		state_change_timer.wait_time = randi_range(1,3)
		state_change_timer.start()
	if state == states.sick:
		var inst = poison.instantiate()
		add_child(inst)
		sprite_2d.modulate = Color(0.5, 0.8, 0.5)
	print("entered state " + str(state))
		
		
func exitState(state):
	if state == states.enter_scene:
		disableBypassBorder()
		
func runCurrentState():
	if current_state == states.enter_scene:
		enterScene()
	if current_state == states.leave_scene:
		leaveScene()
	if current_state == states.wander:
		newWander()
	if current_state == states.sick:
		poopInPool()
	if current_state == states.dive:
		dive()
	if current_state == states.idle:
		if state_change_timer.is_stopped():
			changeState(states.wander)
		# If idling in the pool while sick
		# change to sick state
		if sick and swimming:
			changeState(states.sick)
		

func updateSprite():
	if not collidingWithPool():
		swimming = false
	else:
		swimming = true
	
	if swimming:
		animation_player.play("swim")
	else:
		animation_player.play("run")

func _ready():
	evil_action_complete = false
	doing_evil_action = false
	# Assign random diver, sickness, etc
	var temp = randi_range(0,3)
	if temp == 0:
		print("im gonna be diving today!")
		diver = true
	if temp == 1:
		sick = true
		print("im gonna be sick today!")
	if temp == 2:
		print("im gonna be combination of sick and diver!")
		diver = true
		sick = true
	print(temp)
	current_speed = walking_speed
	selectRandomTextureVariant()
	# Change State
	changeState(states.enter_scene)

func _process(delta):
	#if Input.is_action_just_pressed("left_click"):
		#dialog_box.loadRandomDialog()
		#dialog_box.displayDialog()
		#changeState(states.wander)
	runCurrentState()
	flipSprite()
	deleteWhenFarAway()
	move_and_slide()

		
func poopInPool():
	#print("poop time")
	if animation_player.current_animation != "die":
		animation_player.play("poop")
	doing_evil_action = true
	#await animation_player.animation_finished
	
func randomDialog():
	if randi_range(1,300) == 1:
		dialog_box.displayRandomDialog()

func enterScene():
	updateSprite()
	# Wandering civilian can walk through world borders
	# when spawned off screen
	enableBypassBorder()
	distance = Global.pool_center_position - position
	direction = (distance).normalized()
	velocity = direction * current_speed
	#print(distance.length())
	if distance.length() <= randi_range(200,300) or collidingWithPool():
	#if distance.length() <= randi_range(200,300):
		changeState(states.wander)

func leaveScene():
	updateSprite()
	# Wandering civilian can walk through world borders
	# when spawned off screen
	enableBypassBorder()
	distance =  position - Global.pool_center_position
	direction = (distance).normalized()
	velocity = direction * current_speed

func newWander():
	velocity = direction*current_speed
	updateSprite()
	randomDialog()
	if state_change_timer.is_stopped():
		print("doneee")
		changeState(states.idle)
	if collidingWithPool() and diver:
		changeState(states.dive)
		
func dive():
	direction = (Global.pool_center_position - position).normalized()
	velocity = direction * 50
	doing_evil_action = true
	print("imma dive now")
	if animation_player.current_animation != "die":
		animation_player.play("dive")
	# move in direction of pool
	doing_evil_action = true			

func collidingWithPool():
	#If wanderer collides with the pool, walk away from the pool
	for area in floor_area_2d.get_overlapping_bodies():
		if area.name.to_lower() == "pool":
			return true
	return false

func _on_ready_to_leave_timer_timeout():
	#ready_to_leave = true
	current_state = states.leave_scene
	print("ready to go")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "dive":
		print("HE DOVE INTO THE POOL")
		doing_evil_action = false
		setevilComplete()
		velocity = Vector2(0,0)
		swimming = true
		diver = false
		current_speed = swim_speed
		changeState(states.wander)
	if anim_name == "poop":
		doing_evil_action = false
		setevilComplete()
		#Global.scoreboard.removePoints(scoreWhenEvilIsDone)
		print("HE DONE DOODOO'D IN THE POOL")
		sick = false
		ready_to_leave = true
		changeState(states.leave_scene)
	if anim_name == "die":
		queue_free()



