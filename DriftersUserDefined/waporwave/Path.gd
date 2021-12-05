extends Drifter
func evolve():
	if randf()<.05:
		tweak()
	if randf()<.15:
		intend_die()
func tweak():
	var vibe:Vibe = world.vibe_nearby(cell)
	if vibe.get_element(Vibe.Element.Earth) >= 7:
		intend_transmute("res://DriftersUserDefined/waporwave/House.tscn")
