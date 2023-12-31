extends Control
@onready var health: int = 0
@onready var max_health: int = 100
@onready var lose = preload("res://UI/lose_screen.tscn")
@onready var progress_bar = $ProgressBar

func _ready():
	health = max_health
	updateScore()
	Global.scoreboard = self

func updateScore():
	self.text = "Health: " + str(health) + "/" + str(max_health)
	progress_bar.value = health

func addPoints(points):
	self.health += points
	
	if health >= max_health:
		health = max_health
		
	updateScore()
	
	
func removePoints(points):
	self.health -= points
	if health <= 0:
		Global.gameover=true
		health = 0
		if not Global.winner:
			var inst = lose.instantiate()
			get_parent().get_node("WinLose").visible = true
			get_parent().get_node("WinLose").add_child(inst)
	updateScore()
	
