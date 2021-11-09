extends Drifter

#func _ready():
#	$CPUParticles2D.preprocess = randf()
#	$CPUParticles2D.restart()

func evolve():
	intend_transmute("res://DriftersUserDefined/droqen-debug/BigSnail.tscn")

func tweak():
	queue_free()
