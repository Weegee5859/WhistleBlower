extends "res://Entities/entity.gd"
@onready var animation_player = $AnimationPlayer
@onready var whistle = $whistle


func _ready():
	Global.gameover = false
	Global.winner = false
	

func _input(event):
	if Input.is_action_just_pressed("left_click"):
		if Global.gameover or Global.winner: return
		animation_player.play("blow_whistle")
		whistle.play()

func _process(delta):
	if not animation_player.is_playing():
		animation_player.play("idle")
