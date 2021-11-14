extends Drifter


func evolve():
	var flip = randi()%3 > 0
	if flip:
		var vibe = world.vibe_nearby(cell)
		var dir = DirsAdjacent[randi()%8]
		if vibe.get_grass() > 0 or vibe.get_gem() > 0:
			dir = vibiest_dir(DirsAdjacent,{"Grass":-2, "Gem":-1})
		intend_move(dir)
	else:
		flip = randi()%2 > 0
		if flip:
			var dir = vibiest_dir(DirsAdjacent,{"Grass":-1, "Fire":-1, "Gem": -1})
			intend_spawn("res://DriftersUserDefined/jack/dust.tscn", dir)
		else:
			intend_die()
	
func tweak():
	queue_free()
