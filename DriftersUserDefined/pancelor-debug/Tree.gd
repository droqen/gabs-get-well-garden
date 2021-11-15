extends Drifter

var leaves_left:int

func _ready():
	leaves_left = rand_range(3,6+1)
	scale = Vector2(1,0)
	target_scale = Vector2(1,rand_range(0.8,1.3))

func evolve():
	var vibe:Vibe = world.vibe_nearby(cell)
	if vibe.get_fire() > 5:
		world.log("a tree bursts into flames")
		intend_transmute("res://DriftersUserDefined/pancelor-debug/Flames.tscn")
	elif vibe.get_coal() > 4:
		world.log("a tree dies of sickness")
		intend_transmute("res://DriftersUserDefined/pancelor-debug/DeadTree.tscn")
	else:
		tweak()

func tweak():
	# drop leaves
	# will likely not overwrite existing neghbors, since leaves have low guts
	intend_spawn("res://DriftersUserDefined/pancelor-debug/Leaf.tscn", DirsOrthogonal[randi()%4])
	leaves_left -= 1
	if leaves_left <= 0:
		world.log("a tree has lost all its leaves")
		intend_transmute("res://DriftersUserDefined/pancelor-debug/DeadTree.tscn")
