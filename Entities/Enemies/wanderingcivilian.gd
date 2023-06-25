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

func updateSprite():
	if swimming:
		animation_player.play("swim")
	else:
		animation_player.play("run")
		return
	if collidingWithPool():
		animation_player.play("swim")
	else:
		animation_player.play("run")
	return

func _ready():
	# Assign random diver
	print(str(randi_range(1,10) % 2))
	if randi_range(1,10) % 2:
		diver = false
	diver = true
	print(diver)
	current_speed = walking_speed
	selectRandomTextureVariant()

func _process(delta):
	# When civilian is spawned in, it will walk towards the pool until it reaches
	# a good position in the level
	if not ready_to_wander:
		updateSprite()
		# Wandering civilian can walk through world borders
		# when spawned off screen
		enableBypassBorder()
		distance = Global.pool_center_position - position
		direction = (Global.pool_center_position - position).normalized()
		velocity = direction * current_speed
		#print(distance.length())
		if distance.length() <= randi_range(350,500) or collidingWithPool():
		#if distance.length() <= randi_range(200,300):
			ready_to_wander = true
			direction = direction*-1
	if ready_to_wander:
		wander()
		deleteWhenFarAway()
	#updateSprite()
	flipSprite()
	move_and_slide()
		
func wander():
	if ready_to_leave:
		updateSprite()
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
		if collidingWithPool() and diver and not swimming:
			print("imma dive now")
			animation_player.play("dive")
			print(animation_player.current_animation)
			#await animation_player.animation_finished
			velocity = Vector2(0,0)
			swimming = true
			current_speed = swim_speed
		#if collidingWithPool() and not can_swim:
			# make direction face away from the pools center
			# so the civilian can walk away
			#direction = (position - Global.pool_center_position).normalized()
		if not collidingWithPool() and swimming:
			#await animation_player.animation_finished
			#print("done diving time to swim")
			#current_speed = swim_speed
			animation_player.play("run")
			# Walk in direction
		if animation_player.current_animation != "dive":
			velocity = direction*swim_speed
	# whenever the wandering timer is stopped
	# get a new random direction to wander in
	# and then start the idle timer to idle
	if wandering_timer.is_stopped():
		idle_timer.wait_time = randf_range(1,2)
		idle_timer.start()
		# idle timer with random time
		direction = Vector2(randf_range(1,1),randf_range(1,1))
		wandering_timer.wait_time = randi_range(2,3)
		wandering_timer.start()
		

func collidingWithPool():
	#If wanderer collides with the pool, walk away from the pool
	for area in floor_area_2d.get_overlapping_bodies():
		if area.name.to_lower() == "pool":
			return true
	return false

func _on_ready_to_leave_timer_timeout():
	ready_to_leave = true
	print("ready to go")
