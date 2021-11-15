extends Drifter

# every so often
func evolve():
	tweak()

# when the player clicks
func tweak():
	if randf()*20<1:
		intend_transmute("res://DriftersUserDefined/pancelor-debug/Fish.tscn")
	elif randf()*20<1:
		intend_clone(DirsOrthogonal[randi()%4])
	elif randf()*20<1:
		intend_die()
		
