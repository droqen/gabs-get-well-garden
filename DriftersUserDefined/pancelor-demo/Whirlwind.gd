extends Drifter

onready var ttl:float = rand_range(15, 50+1) # number of evolves until death

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
		var mydir = vibiest_dir(DirsAdjacent,{"Guts":-0.05})
		intend_move(mydir)
		for dir in DirsAdjacent:
			var pos = cell+dir
			world.intend_move_from_to(pos, pos+mydir)
