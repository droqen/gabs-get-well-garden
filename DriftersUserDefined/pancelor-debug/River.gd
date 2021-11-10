extends Drifter

# when the player clicks
func tweak():
	if randf()*20<1:
		intend_transmute("res://DriftersUserDefined/pancelor-debug/Fish.tscn")
	else:
		intend_clone(DirsOrthogonal[randi()%4])
