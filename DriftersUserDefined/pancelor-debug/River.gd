extends Drifter

# when the player clicks
func tweak():
	intend_clone(DirsOrthogonal[randi()%4])
