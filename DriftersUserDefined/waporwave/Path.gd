extends Drifter
func evolve():
	if randf()<.05:
		var vibe:Vibe = world.vibe_nearby(cell)
		if vibe.get_element(Vibe.Element.Earth) >= 9:
			intend_transmute("res://DriftersUserDefined/waporwave/House.tscn")
		else:
			intend_die()
func tweak():
	pass
