extends Drifter

func evolve():
	pass
	
func tweak():
	print("tweak")
	intend_spawn(_my_own_path,DirsOrthogonal[randi()%4])
	
