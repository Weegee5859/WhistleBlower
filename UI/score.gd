extends Control
@onready var score: int = 100

func _ready():
	Global.scoreboard = self

func updateScore():
	self.text = "Score: " + str(score)

func addPoints(points):
	self.score += points
	updateScore()
	
func removePoints(points):
	self.score -= points
	updateScore()
