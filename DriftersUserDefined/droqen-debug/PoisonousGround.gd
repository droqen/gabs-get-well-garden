extends Drifter

onready var BIG_SNAIL = validated_drifter_path("res://DriftersUserDefined/droqen-debug/BigSnail.tscn")

func evolve():
	tweak()
	
func tweak():
	if randf()<0.85:
		intend_die()
	else:
		world.log("a noxious snail emerges")
		intend_transmute(BIG_SNAIL)
