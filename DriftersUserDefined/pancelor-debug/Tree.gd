extends Drifter

var min_leaves_left:int = 2

func evolve():
	if min_leaves_left <= 0 and randf()<0.2:
		# die
		intend_transmute("res://DriftersUserDefined/pancelor-debug/DeadTree.tscn")
	else:
		tweak()

func tweak():
	# drop leaves
	# will likely not overwrite existing neghbors, since leaves have low guts
	intend_spawn("res://DriftersUserDefined/pancelor-debug/Leaf.tscn", DirsOrthogonal[randi()%4])
	min_leaves_left -= 1
