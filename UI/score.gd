extends Control
@onready var health: int = 0
@onready var max_health: int = 100

func _ready():
	health = max_health
	updateScore()
	Global.scoreboard = self

func updateScore():
	self.text = "Health: " + str(health) + "/" + str(max_health)

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
	updateScore()
	
