extends Drifter
func evolve():
	if randf()<.65:
		var vibe:Vibe = world.vibe_nearby(cell)
		if vibe.get_element(Vibe.Element.Earth) < 6:
			intend_transmute("res://DriftersUserDefined/waporwave/Path.tscn")
			world.log("A peeple house crumbles in disrepair")
func tweak():
	if randf()<.25:
		intend_transmute("res://DriftersUserDefined/waporwave/Peeple.tscn")
	else:
		intend_transmute("res://DriftersUserDefined/waporwave/Path.tscn")
