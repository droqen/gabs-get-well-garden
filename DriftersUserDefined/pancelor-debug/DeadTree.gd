extends Drifter

func evolve():
	var vibe:Vibe = world.vibe_nearby(cell)
	if vibe.get_element(Vibe.Element.Fire) > 2:
		world.log("a dead tree bursts into flames")
		intend_transmute("res://DriftersUserDefined/pancelor-debug/Flames.tscn")
	
func tweak():
	intend_spawn(_my_own_path,DirsOrthogonal[randi()%4])
