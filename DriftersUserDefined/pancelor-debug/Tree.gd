extends Drifter

var leaves_left:float
onready var DEAD_TREE = validated_drifter_path("res://DriftersUserDefined/pancelor-debug/DeadTree.tscn")
onready var LEAF = validated_drifter_path("res://DriftersUserDefined/pancelor-debug/Leaf.tscn")

func _ready():
	leaves_left = rand_range(3,7+1)
	scale = Vector2(1,0)
	target_scale = Vector2(1,rand_range(0.8,1.3))

func evolve():
	var vibe:Vibe = world.vibe_nearby(cell)
	if vibe.get_grass() > 6:
		leaves_left += 0.5
	
	if vibe.get_fire() > 5:
		world.log("a tree shrivels in the heat")
		intend_transmute(DEAD_TREE)
	elif vibe.get_coal() > 4:
		world.log("a tree dies of sickness")
		intend_transmute(DEAD_TREE)
	else:
		tweak()

func tweak():
	if leaves_left <= 0:
		if randf()*8<1:
			world.log("a wisened old tree begins to fade")
			intend_transmute(DEAD_TREE)
	else:
		# drop leaves
		leaves_left -= 1
		var emptydir = vibiest_dir(DirsAdjacent,{"Guts":-1})
		intend_spawn(LEAF, emptydir)
