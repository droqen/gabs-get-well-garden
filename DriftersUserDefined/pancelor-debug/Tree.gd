extends Drifter

var min_leaves_left = 2

func evolve(vibe:Vibe):
	if min_leaves_left <= 0 and randf()<0.2:
		# die
		intent_spawn_drifter = load("res://DriftersUserDefined/pancelor-debug/DeadTree.tscn").instance()
		intent_spawn_dir = Vector2.ZERO
		guts = 0
	else:
		tweak(vibe)

func tweak(_vibe:Vibe):
	# drop leaves
	# will likely not overwrite existing neghbors, since leaves have low guts
	intent_spawn_drifter = load("res://DriftersUserDefined/pancelor-debug/Leaf.tscn").instance()
	intent_spawn_dir = DirsOrthogonal[randi()%4]
	min_leaves_left -= 1
#
#func randf_print():
#	var x = randf()
#	print(x)
#	return x
