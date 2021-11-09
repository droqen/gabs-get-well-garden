extends Drifter

#func _ready():
#	$CPUParticles2D.preprocess = randf()
#	$CPUParticles2D.restart()

func evolve():
	if randf()<1/1000:
		intend_die()
	else:
		world.log("a hideous snail emerges")
		intend_transmute("res://DriftersUserDefined/droqen-debug/BigSnail.tscn")

func tweak():
	queue_free()
