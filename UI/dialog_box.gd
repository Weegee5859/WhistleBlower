extends Control

@onready var label = $ColorRect/Label
@onready var text_speed: float = 0.05
@onready var timer = $TextTimer
@onready var remove_dialog_timer = $RemoveDialogTimer


var dialog = ""
var currently_writing_dialog: bool
var dialog_list: Array[String] = [
	"blah blah blah blah",
	"The weather is great!",
	"So let me get this straight..",
	"And they were roomates...!",
	"Anyways, I started blastin...",
	"Whopper whopper chicken whopper!",
	"Hahahahaha",
	"Look at me go!"
]

func loadRandomDialog():
	dialog = dialog_list[randi_range(0,dialog_list.size()-1)]
	
		
func displayDialog():
	# Make DialogBox Visble
	self.visible = true
	# If Dialog is currently being written
	# Stop trying to write dialog
	if currently_writing_dialog: return
	# Empty current label of dialog
	label.text = ""
	# Write dialog to label
	currently_writing_dialog = true
	for letter in dialog:
		label.text += letter
		timer.start()
		await timer.timeout
	# done writing dialog to label
	currently_writing_dialog = false
	# When timer is done, dialog with be disappear
	remove_dialog_timer.start()
	
func displayRandomDialog():
	loadRandomDialog()
	displayDialog()
	
		
func _ready():
	timer.wait_time = text_speed
	loadRandomDialog()
	self.visible = false
	


func _on_remove_dialog_timeout():
	print("done and done")
	self.visible = false
