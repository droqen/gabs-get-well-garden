extends Drifter

func evolve(vibe:Vibe):
	if randf()<0.02:
		# grow
		tweak(vibe)

func tweak(_vibe:Vibe):
	intent_spawn_drifter = load("res://DriftersUserDefined/pancelor-debug/Tree.tscn").instance()
	intent_spawn_dir = Vector2.ZERO
	guts = 0
	
