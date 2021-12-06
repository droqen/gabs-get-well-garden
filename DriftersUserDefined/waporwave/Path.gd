extends Drifter
func evolve():
	if randf()<.05:
		if randf()<0.25: intend_die()
		else: tweak()
func tweak():
	var vibe:Vibe = world.vibe_nearby(cell)
	if vibe.get_element(Vibe.Element.Earth) >= 7:
		intend_transmute("res://DriftersUserDefined/waporwave/House.tscn")
