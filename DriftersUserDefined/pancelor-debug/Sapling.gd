extends Drifter

func evolve(): #todo
	if randf()<0.02:
		# grow
		tweak()

func tweak():
	intent_spawn_drifter = "res://DriftersUserDefined/pancelor-debug/Tree.tscn"
	intent_spawn_dir = Vector2.ZERO
	guts = 0
