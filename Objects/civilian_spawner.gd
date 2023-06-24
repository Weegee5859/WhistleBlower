extends Node2D
@onready var cooldown_timer = $CooldownTimer
@export var cooldown_time: int = 5
@onready var civilian

@export var civilians: Array[Resource]
func _ready():
	# set the cooldown timer to specified time
	cooldown_timer.wait_time = cooldown_time
	
	
func _process(delta):
	# whenever the cooldown stops, add a random civilian
	# from the array of civilians
	if cooldown_timer.is_stopped():
		# select a random number out of the total number of Civilians
		# in the civilians array
		var random_num: int = randi_range(0,civilians.size()-1)
		# instantiate the randomly selected civilian
		var civilian_instance = civilians[random_num].instantiate()
		# add the random civilian to the level
		get_parent().add_child(civilian_instance)
		# reset the cooldown timer
		cooldown_timer.start()

# manually add a civilian to the list of civilians array
# I would just use the export var civilians on the right
# and add the civilian.tscn file to the array with (Add Element)
func addCivilian(civilian_pre_load: Resource):
	civilians.append(civilian_pre_load)
	
