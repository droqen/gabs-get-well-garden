extends Drifter

func _init():
	scale = Vector2(1,rand_range(0.8,1.3))

func evolve():
	var vibe:Vibe = world.vibe_nearby(cell)
	if vibe.get_fire() > 2:
		world.log("a dead tree bursts into flames")
		intend_transmute("res://DriftersUserDefined/pancelor-debug/Flames.tscn")
	
func tweak():
	intend_die()
