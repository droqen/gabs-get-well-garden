extends Drifter

var ticks = 0


func evolve():
	#if randi()%300 == 0:
	var vibe = world.vibe_nearby(cell);
	if vibe.get_fire() > 0:
		ticks += 1
		
	if ticks > 10:
		intend_die()
	
func tweak():
	$Sprite.flip_h = not $Sprite.flip_h
