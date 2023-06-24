extends Label
@onready var shift_timer = $ShiftTimer
# This is how many real time minutes the game will last
@onready var minutes: float = 1
@onready var minutes_in_seconds: float = minutes * 60
@onready var shift_hours: float = 8
@onready var shift_start_time: float = 9
@onready var shift_over: bool
@onready var current_time_percentage: float
@onready var percentage_of_shift: float
@onready var current_percentage_of_shift: float
@onready var current_time: float
# Shift is from 9:00 to 17:00 aka 9am to 5pm
func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)
	
func convertToClockTime(current_time: float):
	var seconds = round( ((current_time-floor(current_time))) * 60 )
	seconds = round(seconds)
	if seconds<10:
		seconds = "0" + str(seconds)
	#seconds = 60 * float(seconds)
	var suffix="am"
	if current_time >=13:
		current_time-=12
		suffix="pm"
	return str(floor(current_time)) + ":" + str(seconds) + " " + str(suffix)
		

func _ready():
	
	shift_timer.wait_time = minutes_in_seconds
	shift_timer.start()
	
func _process(delta):
	# Math Stuff I dont rly understand but...
	# It makes the clock work so
	# 
	current_time_percentage = (shift_timer.time_left / minutes_in_seconds) * 100
	percentage_of_shift = (shift_hours * current_time_percentage) / 100
	current_percentage_of_shift = shift_hours - percentage_of_shift
	current_time = round_to_dec( shift_start_time + (shift_hours - percentage_of_shift), 2)
	self.text = str(convertToClockTime(current_time))


func _on_shift_timer_timeout():
	shift_over = true
