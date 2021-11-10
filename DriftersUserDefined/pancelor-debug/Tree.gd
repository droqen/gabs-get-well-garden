extends Drifter

var min_leaves_left:int = 2

func evolve():
	var vibe:Vibe = world.vibe_nearby(cell)
	if vibe.get_fire() > 5:
		world.log("a tree bursts into flames")
		intend_transmute("res://DriftersUserDefined/pancelor-debug/Flames.tscn")
	elif vibe.get_coal() > 5:
		world.log("a tree dies of sickness")
		intend_transmute("res://DriftersUserDefined/pancelor-debug/DeadTree.tscn")
	elif min_leaves_left <= 0 and randf()<0.2:
		world.log("a tree has lost all its leaves")
		intend_transmute("res://DriftersUserDefined/pancelor-debug/DeadTree.tscn")
	else:
		tweak()

func tweak():
	# drop leaves
	# will likely not overwrite existing neghbors, since leaves have low guts
	intend_spawn("res://DriftersUserDefined/pancelor-debug/Leaf.tscn", DirsOrthogonal[randi()%4])
	min_leaves_left -= 1
