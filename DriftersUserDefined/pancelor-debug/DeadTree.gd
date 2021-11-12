extends Drifter

func _ready():
	target_scale = Vector2(1,rand_range(0.8,1.3))
	# also, don't set scale to 0

func evolve():
	var vibe:Vibe = world.vibe_nearby(cell)
	if vibe.get_fire() > 2:
		world.log("a dead tree bursts into flames")
		intend_transmute("res://DriftersUserDefined/pancelor-debug/Flames.tscn")
	
func tweak():
	if randf()*50<1:
		world.log("an unlucky spark starts a fire")
		intend_transmute("res://DriftersUserDefined/pancelor-debug/Flames.tscn")
	else:
		target_rotation_degrees = 90
		intend_die()
