extends GPUParticles2D

func _ready():
	emitting = true

func _process(delta):
	if not emitting:
		get_parent().queue_free()
