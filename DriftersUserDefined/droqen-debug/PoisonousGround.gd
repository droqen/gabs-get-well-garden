extends Drifter

func evolve():
	tweak()
	
func tweak():
	if randf()<0.9:
		intend_die()
	else:
		world.log("a noxious snail emerges")
		intend_transmute("res://DriftersUserDefined/droqen-debug/BigSnail.tscn")
