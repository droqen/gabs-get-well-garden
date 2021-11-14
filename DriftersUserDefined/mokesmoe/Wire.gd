extends Drifter

var ready = 0

# every so often
func evolve():
	if ready:
		var vibe = world.vibe_nearby(cell)
		if vibe.get_fire() >= 1 && vibe.get_fire() <= 4:
			intend_transmute("res://DriftersUserDefined/mokesmoe/WireHot.tscn")
			if randf()*50<1:
				# settle
				var dir:Vector2 = vibiest_dir(DirsAdjacent,{"Water":1, "Earth":-5, "Guts":-0.01})
				vibe = world.vibe_nearby(cell+dir)
				if vibe.get_earth() < 3:
					intend_spawn("res://DriftersUserDefined/mokesmoe/Wire.tscn", dir)
					world.log("the wire expands")
	else:
		ready = 1
# when the player clicks
func tweak():
	intend_transmute("res://DriftersUserDefined/mokesmoe/WireHot.tscn")
