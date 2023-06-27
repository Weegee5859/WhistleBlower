extends "res://Entities/entity.gd"
@onready var animation_player = $AnimationPlayer
@onready var whistle = $whistle
@onready var pulse = preload("res://Sprites/particles/click_pulse.tscn")
@onready var super_move_timer = $SuperMoveTimer
@onready var super_meter: int = 3
@onready var super_move_cooldown_timer = $SuperMoveCooldownTimer

func _ready():
	Global.gameover = false
	Global.winner = false
	

func _input(event):
	# if you already won or lost, don't register gameplay inputs
	if Global.gameover or Global.winner: return
	if Input.is_action_just_pressed("left_click"):
		# Add pulse particle effect if clicking
		var inst = pulse.instantiate()
		inst.position = get_global_mouse_position()
		get_parent().add_child(inst)
		animation_player.play("blow_whistle")
		whistle.play()
	if Input.is_action_just_pressed("right_click") and super_move_timer.is_stopped() and super_move_cooldown_timer.is_stopped():
		super_move_timer.start()
		print("started")
	if Input.is_action_just_released("right_click"):
		super_move_timer.stop()
		print("stopped")
	
	

func _process(delta):
	
	if not animation_player.is_playing():
		animation_player.play("idle")


func _on_super_move_timer_timeout():
	if Input.is_action_pressed("right_click") and super_move_cooldown_timer.is_stopped():
		print("super move activate!")
		super_move_cooldown_timer.start()
