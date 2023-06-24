extends Area2D
@onready var marker_2d = $Marker2D


func _ready():
	# Give coordinates to the marker_2d located
	# at the center of the pool  to the Global
	# singleton
	Global.pool_center_position = marker_2d.position
