extends CharacterBody2D

@onready var mouse_colliding: bool
@export var health: int
@export var max_health: int



func _ready():
	max_health = health


# If your mouse hovers over a civilian, set mouse colliding to true
func _on_mouse_area_2d_mouse_entered():
	mouse_colliding = true
	#print(str(self.name) + " mouse is colliding is " + str(mouse_colliding))

# If your mouse leaves a civilian body, set mouse colliding to false
func _on_mouse_area_2d_mouse_exited():
	mouse_colliding = false
	#print(str(self.name) + " mouse is colliding is " + str(mouse_colliding))
