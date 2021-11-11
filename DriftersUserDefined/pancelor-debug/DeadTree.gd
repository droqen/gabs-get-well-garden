extends Drifter

func _ready():
	scale = Vector2(1,rand_range(0.8,1.3))

func _process(_delta):
	if dead:
		rotation_degrees = lerp(rotation_degrees,90,0.05)

func evolve():
	var vibe:Vibe = world.vibe_nearby(cell)
	if vibe.get_fire() > 2:
		world.log("a dead tree bursts into flames")
		intend_transmute("res://DriftersUserDefined/pancelor-debug/Flames.tscn")
	
func tweak():
	if randf()*50<1:
		world.log("an unlucky spark starts a fire")
		intend_transmute("res://DriftersUserDefined/pancelor-debug/Flames.tscn")
	else:
		intend_die()
