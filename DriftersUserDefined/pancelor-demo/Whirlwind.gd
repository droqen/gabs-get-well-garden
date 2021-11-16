extends Drifter

onready var ttl:float = rand_range(15, 50+1) # number of evolves until death
var repeat_dir:bool
var mydir:Vector2

func _physics_process(_delta):
	._physics_process(_delta) # call method on base class 
	if randf()*40<1:
		scale.x *= 1.15
		scale.y *= 1.15
	target_rotation_degrees -= 1
	target_rotation_degrees = wrapf(target_rotation_degrees,0,360)
	rotation_degrees = target_rotation_degrees

func evolve():
	tweak()

func tweak():
	ttl -= 1
	if ttl <= 0:
		world.log("the whirlwind subsides")
		intend_die()
	else:
		if not repeat_dir:
			mydir = vibiest_dir(DirsAdjacent,{"Wind":0.1, "Guts":-0.05})
		repeat_dir = not repeat_dir

		intend_move(mydir)
		for dir in DirsAdjacent:
			var pos = cell+dir
			world.intend_move_from_to(pos, pos+mydir)
