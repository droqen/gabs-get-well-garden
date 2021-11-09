extends Drifter

func evolve():
	var dir = DirsOrthogonal[randi()%4]
	var vibe = world.vibe_nearby(cell+dir)
	if vibe.get_element(Vibe.Element.Water) < 4:
		world.log("the flames grow higher")
		intend_spawn("res://DriftersUserDefined/pancelor-debug/Flames.tscn",dir)
	elif vibe.get_element(Vibe.Element.Fire) > 9:
		world.log("the flames smother themselves, leaving behind new life")
		intend_transmute("res://DriftersUserDefined/pancelor-debug/Sapling.tscn")

func tweak():
	queue_free()
