extends Node2D
@onready var cooldown_timer = $CooldownTimer
@export var min_cooldown_time: int = 2
@export var max_cooldown_time: int = 5
@onready var civilian
@export var offset_y: int
@export var offset_x: int

@export var civilians: Array[Resource]
func _ready():
	# set the cooldown timer to specified time
	cooldown_timer.wait_time = randf_range(min_cooldown_time,max_cooldown_time)
	
	
func _process(delta):
	if Global.gameover: return
	# whenever the cooldown stops, add a random civilian
	# from the array of civilians
	if cooldown_timer.is_stopped():
		# select a random number out of the total number of Civilians
		# in the civilians array
		var random_num: int = randi_range(0,civilians.size()-1)
		# instantiate the randomly selected civilian
		var civilian_instance = civilians[random_num].instantiate()
		# Spawn Civilian a certain distance off from the civilian spawners center
		civilian_instance.position = position
		# set by how much with offset_y (up, down) and offset_x (left, right)
		if offset_y:
			civilian_instance.position.y += randi_range(offset_y*-1,offset_y)
		if offset_x:
			civilian_instance.position.x += randi_range(offset_x*-1,offset_x)
		# add the random civilian to the level
		get_parent().add_child(civilian_instance)
		#cooldown_timer
		cooldown_timer.wait_time = randf_range(min_cooldown_time,max_cooldown_time)
		# reset the cooldown timer
		cooldown_timer.start()

# manually add a civilian to the list of civilians array
# I would just use the export var civilians on the right
# and add the civilian.tscn file to the array with (Add Element)
func addCivilian(civilian_pre_load: Resource):
	civilians.append(civilian_pre_load)
	
