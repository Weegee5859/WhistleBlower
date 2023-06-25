extends Control
@onready var label = $ColorRect/VBoxContainer/Label
@onready var text_speed: float = 0.05
@onready var timer = $Timer
var dialog = ""
var dialog_list: Array[String] = [
	"blah blah blah blah",
	"The weather is great!",
	"So let me get this straight..",
	"And they were roomates...!",
	"Anways, I started blastin...",
	"Whopper whopper chicken whopper!",
	"Hahahahaha",
	"Look at me go!"
]

func loadRandomDialog():
	dialog = dialog_list[randi_range(0,dialog_list.size()-1)]
	for letter in dialog:
		label.text += letter
		timer.start()
		await timer.timeout
		
func _ready():
	timer.wait_time = text_speed
	loadRandomDialog()
