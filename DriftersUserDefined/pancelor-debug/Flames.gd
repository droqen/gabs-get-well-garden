extends Drifter

var anim = 0.0

func _process(_delta):
	anim += _delta
	$Sprite.scale = Vector2(1, 1+(sin((anim)*4*PI)/10))
	$Sprite.rotation_degrees = (sin(anim*2*PI))*10

func evolve():
	var dir = DirsOrthogonal[randi()%4]
	var vibe = world.vibe_nearby(cell+dir)
	if vibe.get_water() < 4:
		world.log("the flames grow higher")
		intend_spawn("res://DriftersUserDefined/pancelor-debug/Flames.tscn",dir)
	elif vibe.get_fire() > 9:
		world.log("the flames smother themselves, leaving behind new life")
		intend_transmute("res://DriftersUserDefined/pancelor-debug/Sapling.tscn")

func tweak():
	queue_free()
