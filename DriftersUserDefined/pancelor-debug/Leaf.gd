extends Drifter

func _process(_delta):
	if randf()<0.02:
		$Sprite.scale = Vector2(1.1, 0.9)
		$Sprite.rotation_degrees = rand_range(-20,20)
	else:
		$Sprite.scale = lerp($Sprite.scale, Vector2(0.9, 1.1), 0.02)
		$Sprite.rotation_degrees = lerp($Sprite.rotation_degrees, 0, 0.05)
		
func evolve():
	var vibe:Vibe = world.vibe_nearby(cell)
	if vibe.get_element(Vibe.Element.Fire) > 1:
		world.log("a wandering leaf bursts into flames")
		intend_transmute("res://DriftersUserDefined/pancelor-debug/Flames.tscn")
	elif randf()<1/50:
		# settle
		tweak()
	else:
		# move towards wind but away from guts:
		var dir = vibiest_dir(DirsAdjacent,{"Wind":1, "Guts":-2})
		$Sprite.scale = Vector2(1.2, 0.8)
		if dir.x: $Sprite.flip_h = dir.x < 0
		
		intend_move(dir)

func tweak():
	intend_transmute("res://DriftersUserDefined/pancelor-debug/Sapling.tscn")
