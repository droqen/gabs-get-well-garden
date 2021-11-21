extends Drifter

# Design by pancelor + Pinchazumos
# Sprite by Pinchazumos

var anim:float

func _physics_process(delta):
	._physics_process(delta)
	anim += delta
	modulate.a = (sin(anim)+1)/2.0
	if randf()*30<1:
		scale *= Vector2(1.2,0.8)

func _ready():
	change_color(Vibe.Element.Grass)
	
func evolve():
	var vibe = world.vibe_nearby(cell)
	var maxelem = Vibe.Element.get(vibe.max_element())
	if vibe.get_element(maxelem) > 2:
		change_color(maxelem)
	if randf()*3<1:
		move()

func tweak():
	var elem = randi()%8+1
	change_color(elem)
	move()
	
func change_color(elem:int):
	major_element = elem

	match elem:
		Vibe.Element.Fire:  modulate = Color.from_hsv(0,1,1,modulate.a)
		Vibe.Element.Water: modulate = Color.from_hsv(230/360.0,1,1,modulate.a)
		Vibe.Element.Earth: modulate = Color.from_hsv(37/360.0,1,0.7,modulate.a)
		Vibe.Element.Grass: modulate = Color.from_hsv(135/360.0,1,1,modulate.a)
		Vibe.Element.Wind:  modulate = Color.from_hsv(184/360.0,0.3,1,modulate.a)
		Vibe.Element.Sand:  modulate = Color.from_hsv(59/360.0,1,1,modulate.a)
		Vibe.Element.Gem:   modulate = Color.from_hsv(290/360.0,1,1,modulate.a)
		Vibe.Element.Coal:  modulate = Color.from_hsv(250/360.0,1,0.1,modulate.a)

func move():
	var dir = vibiest_dir(DirsAdjacent, {"Guts":-0.02})
	if dir.x: $NavdiBitsySprite.flip_h = dir.x<0
	intend_move(dir)
