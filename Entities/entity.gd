extends CharacterBody2D

@onready var mouse_colliding: bool
@export var health: int
@export var max_health: int

@export var speed: float

func _ready():
	max_health = health


func _on_mouse_area_2d_mouse_entered():
	mouse_colliding = true
	print(str(self.name) + " mouse is colliding is " + str(mouse_colliding))


func _on_mouse_area_2d_mouse_exited():
	mouse_colliding = false
	print(str(self.name) + " mouse is colliding is " + str(mouse_colliding))
