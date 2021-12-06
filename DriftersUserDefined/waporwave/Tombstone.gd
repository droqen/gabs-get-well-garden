extends Drifter
func evolve():
	if randf()<.01:
		if randf()<0.25: intend_die()
		else: tweak()
func tweak():
	var vibe:Vibe = world.vibe_nearby(cell)
	if vibe.get_element(Vibe.Element.Coal) >= 3:
		intend_transmute("res://DriftersUserDefined/waporwave/Zomby.tscn")
	else:
		intend_transmute("res://DriftersUserDefined/waporwave/Gost.tscn")
