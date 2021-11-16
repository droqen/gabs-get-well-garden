extends Drifter

# every so often
func evolve():
	tweak()

# when the player clicks
func tweak():
	world.log("new life grows")
	intend_transmute("res://DriftersUserDefined/pancelor-debug/Tree.tscn")
