extends "res://Entities/entity.gd"
@onready var animation_player = $AnimationPlayer


func _input(event):
	if Input.is_action_just_pressed("left_click"):
		animation_player.play("blow_whistle")

func _process(delta):
	if not animation_player.is_playing():
		animation_player.play("idle")
