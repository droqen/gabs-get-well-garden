extends Drifter

# every so often
func evolve():
	tweak()

func tweak():
	world.log("new life grows")
	intend_transmute("res://DriftersUserDefined/pancelor-debug/Tree.tscn")
