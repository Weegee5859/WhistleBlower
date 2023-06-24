extends "res://Entities/Enemies/civilian.gd"
@onready var idle_timer = $IdleTimer
@onready var wandering_timer = $WanderingTimer
@onready var ready_to_wander: bool
@export var walking_speed: int = 150
@onready var distance: Vector2 = Vector2(0,0)
@onready var direction: Vector2 = Vector2(0,0)
@onready var ready_to_leave_timer = $ReadyToLeaveTimer


func _ready():
	current_speed = walking_speed

func _process(delta):
	# When civilian is spawned in, it will walk towards the pool until it reaches
	# a good position in the level
	if not ready_to_wander:
		# Wandering civilian can walk through world borders
		# when spawned off screen
		enableBypassBorder()
		distance = Global.pool_center_position - position
		direction = (Global.pool_center_position - position).normalized()
		velocity = direction * current_speed
		if distance.length() <= 250 or collidingWithPool():
			ready_to_wander = true
			direction = direction*-1
	
	if ready_to_wander:
		wander()
		deleteWhenFarAway()

	move_and_slide()
		
func wander():
	if ready_to_leave:
		leave()
		return
	# when wandering, it cannt pass world border
	disableBypassBorder()
	# If the idle timer is running idle
	if not idle_timer.is_stopped():
		velocity = Vector2(0,0)
	# Wandering timer is running so we can wander
	# only if the idle timer is not running at the same time
	if not wandering_timer.is_stopped() and idle_timer.is_stopped():	
		if collidingWithPool():
			# make direction face away from the pools center
			# so the civilian can walk away
			direction = (position - Global.pool_center_position).normalized()
		# Walk in direction
		velocity = direction*current_speed
	# whenever the wandering timer is stopped
	# get a new random direction to wander in
	# and then start the idle timer to idle
	if wandering_timer.is_stopped():
		idle_timer.wait_time = randf_range(1,2)
		idle_timer.start()
		# idle timer with random time
		direction = Vector2(randf_range(-1,1),randf_range(-1,1))
		wandering_timer.wait_time = randi_range(2,3)
		wandering_timer.start()

func collidingWithPool():
	#If wanderer collides with the pool, walk away from the pool
	for area in mouse_area_2d.get_overlapping_areas():
		if area.name.to_lower() == "pool":
			return true
	return false

func _on_ready_to_leave_timer_timeout():
	ready_to_leave = true
	print("ready to go")
