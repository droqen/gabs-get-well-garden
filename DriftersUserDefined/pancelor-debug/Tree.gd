extends Drifter

var min_leaves_left:int = 2

func evolve(vibe:Vibe):
	if min_leaves_left <= 0 and randf()<0.2:
		# die
		intent_spawn_drifter = "res://DriftersUserDefined/pancelor-debug/DeadTree.tscn"
		intent_spawn_dir = Vector2.ZERO
		guts = 0
	else:
		tweak(vibe)

func tweak(_vibe:Vibe):
	# drop leaves
	# will likely not overwrite existing neghbors, since leaves have low guts
	intent_spawn_drifter = "res://DriftersUserDefined/pancelor-debug/Leaf.tscn"
	intent_spawn_dir = DirsOrthogonal[randi()%4]
	min_leaves_left -= 1
