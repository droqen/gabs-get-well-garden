extends Drifter


func evolve():
	var vibe:Vibe = world.vibe_nearby(cell)
	$Sprite.scale.y = (vibe.get_coal()/3)+1
	
func tweak():
	pass
