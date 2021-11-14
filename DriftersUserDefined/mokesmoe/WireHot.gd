extends Drifter

var ready = 0

# every so often
func evolve():
	if ready:
		intend_transmute("res://DriftersUserDefined/mokesmoe/WireCold.tscn")
	else:
		ready = 1

# when the player clicks
func tweak():
	intend_die()
