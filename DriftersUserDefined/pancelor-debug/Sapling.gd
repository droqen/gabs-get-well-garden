extends Drifter

onready var TREE = validated_drifter_path("res://DriftersUserDefined/pancelor-debug/Tree.tscn")

# every so often
func evolve():
	tweak()

# when the player clicks
func tweak():
	world.log("new life grows")
	intend_transmute(TREE)
