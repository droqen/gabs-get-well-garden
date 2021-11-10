extends Drifter

#func _ready():
#	$CPUParticles2D.preprocess = randf()
#	$CPUParticles2D.restart()

func evolve():
	if randf()*10<1:
		intend_die()
	else:
		world.log("a noxious snail emerges")
		intend_transmute("res://DriftersUserDefined/droqen-debug/BigSnail.tscn")

func tweak():
	queue_free()
