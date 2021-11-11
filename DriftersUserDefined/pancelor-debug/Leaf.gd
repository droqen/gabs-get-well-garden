extends Drifter

func _process(_delta):
	if randf()*50<1:
		scale = Vector2(1.1, 0.9)
		rotation_degrees = rand_range(-20,20)
	else:
		scale = lerp(scale, Vector2(0.9, 1.1), 0.02)
		rotation_degrees = lerp(rotation_degrees, 0, 0.05)
		
func evolve():
	var vibe:Vibe = world.vibe_nearby(cell)
	if vibe.get_fire() > 1:
		world.log("a wandering leaf bursts into flames")
		intend_transmute("res://DriftersUserDefined/pancelor-debug/Flames.tscn")
	elif randf()*50<1:
		# settle
		tweak()
	else:
		# move towards wind but away from guts:
		var dir
		if randf()*2<1:
			dir = vibiest_dir(DirsAdjacent,{"Wind":1})
		else:
			dir = vibiest_dir(DirsAdjacent,{"Guts":-1})
		scale = Vector2(1.2, 0.8)
		if dir.x: $Sprite.flip_h = dir.x<0
		
		intend_move(dir)

func tweak():
	world.log("a leaf settles down")
	intend_transmute("res://DriftersUserDefined/pancelor-debug/Sapling.tscn")
