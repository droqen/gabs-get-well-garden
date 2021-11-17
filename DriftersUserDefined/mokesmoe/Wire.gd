extends Drifter

var ready = 0

# every so often
func evolve():
	if ready:
		var vibe = world.vibe_nearby(cell)
		if vibe.get_fire() >= 1 && vibe.get_fire() <= 4:
			intend_transmute("res://DriftersUserDefined/mokesmoe/WireHot.tscn")
	else:
		ready = 1
# when the player clicks
func tweak():
	intend_transmute("res://DriftersUserDefined/mokesmoe/WireHot.tscn")
