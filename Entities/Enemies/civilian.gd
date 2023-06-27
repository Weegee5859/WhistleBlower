extends "res://Entities/entity.gd"
@export var doing_evil_action: bool = false
@export var evil_action_complete: bool = false
@onready var got_caught_movement_speed: int = 0
@onready var sad_movement_speed: int = 50
@export var default_speed: int = 10
@export var current_speed: int
@onready var mouse_area_2d = $MouseArea2D
@onready var collision = $Area2D/CollisionShape2D
@onready var floor_area_2d = $FloorArea2D
@onready var floor_collision = $FloorCollision
@onready var scoreWhenCaught: int = 10
@onready var scoreWhenWrong: int = 5
@onready var scoreWhenEvilEscaped: int = 10
@onready var scoreWhenEvilIsDone: int = 15
@onready var scoreWhenInnocentLeftHappy: int = 5
@onready var ready_to_leave: bool
@onready var sad: bool
@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D
@onready var death_animation_start_pos: Vector2
@onready var death_animation_final_pos: Vector2
@onready var caught: bool

#Particles
@onready var poison = preload("res://Sprites/particles/sick_particle.tscn")

# Civilian textures
@export var texture_variant_array: Array[Texture] = [
	preload("res://Sprites/kid_one.png"),
	preload("res://Sprites/kid_three.png")
]
#Particles
@export var star_particle = preload("res://Sprites/particles/star_particle.tscn")




# If doing evil action or evil action has already occured/completed
func setdoingEvilTrue():
	print("doing evil is trueeeee")
	doing_evil_action = true

func setdoingEvilFalse():
	print("doing evil is falseee")
	doing_evil_action = false

func setevilComplete():
	print("evillllll doneee")
	Global.scoreboard.removePoints(scoreWhenEvilIsDone)
	evil_action_complete = true
	
# Update sprite direction based on velocity
func flipSprite():
	if velocity.x >0:
		sprite_2d.flip_h = true
		if animation_player.current_animation == "swim":
			sprite_2d.rotation = 45
	if velocity.x <0:
		sprite_2d.flip_h = false
		if animation_player.current_animation == "swim":
			sprite_2d.rotation = -45
# Select random civilian texture
func selectRandomTextureVariant():
	sprite_2d.texture = texture_variant_array[randi_range(0,texture_variant_array.size()-1)]

func _ready():
	pass

func die():
	caught = true
	deathMovement()
	animation_player.play("die")
	#await animation_player.animation_finished
	#var new_particle = star_particle.instantiate()
	#new_particle.position = self.global_position
	#get_parent().add_child(new_particle)
	#queue_free()

func _input(event):
	# If you left a civilian do something...
	if Input.is_action_just_pressed("left_click") and mouse_colliding:
		# left_clicked or blew whistle at someone doing an evil action
		if doing_evil_action:
			velocity = Vector2(0,0)
			#animation_player.play("die")
			#await animation_player.animation_finished
			#queue_free()
			print(str(self) + " got caught in the act!")
			caught = true
			Global.scoreboard.addPoints(scoreWhenCaught)
			deathMovement()
			animation_player.play("die")
			#await animation_player.animation_finished
			#var new_particle = star_particle.instantiate()
			#new_particle.position = self.global_position
			#get_parent().add_child(new_particle)
			#queue_free()
		elif evil_action_complete:
			print(str(self) + " was caught but it was too late!")
			caught = true
			deathMovement()
			animation_player.play("die")
			#await animation_player.animation_finished
			#queue_free()
		else:
			# left_clicked or blew whistle at innocent person
			current_speed=sad_movement_speed
			Global.scoreboard.removePoints(scoreWhenWrong)
			sad = true
			ready_to_leave = true
			#await animation_player.animation_finished
			print(str(self) + " was innocent! :(")

func _process(delta):
	move_and_slide()
	
func deleteWhenFarAway():
	var distance = Global.pool_center_position - position
	
	if distance.length() >= 1500:
		queue_free()
		if doing_evil_action:
			print(str(self) + " left the pool after doing EVVVVILLL!")
			Global.scoreboard.removePoints(scoreWhenEvilEscaped)
			return
		if sad:
			print(str(self) + " left the pool sad! :(")
			return
		print(str(self) + " left the pool happy!")
		#Global.scoreboard.addPoints(scoreWhenInnocentLeftHappy)

func enableBypassBorder():
	collision.disabled = true

func disableBypassBorder():
	collision.disabled = false

func canBypassBorder():
	return collision.disabled
	
func leave():
	enableBypassBorder()
	var direction = (position - Global.pool_center_position).normalized()
	velocity = direction*current_speed
	
func deathMovement():
	var direction = Vector2(-1,-1)
	var speed = 0
	velocity = direction*speed


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "die":
		queue_free()
