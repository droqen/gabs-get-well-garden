extends Drifter

func _ready():
	blabber("uuuuu...")
	world.log("a gost appears")

var anim = 0.0
onready var message = load("res://DriftersUserDefined/waporwave/Blabber.tscn")

func _process(_delta):
	anim += _delta
	$Sprite.scale = Vector2(1, 1+(sin((anim)*1*PI)/10))
	$Sprite.rotation_degrees = (sin(anim*.5*PI))*10

func evolve():
	if randf()<.5:
		intend_move(vibiest_dir(DirsAdjacent,{"Grass":1,"Guts":1,"Gem":1,"Fire":1}))
	else:
		intend_move(DirsOrthogonal[randi()%4])
	if randf()<.2:
		for direction in DirsAdjacent:
			var tile = world._get_drifter_at_cell(cell+direction)
			if tile != null:
				blabber("u")
				tile.tweak()
				break
				
	var vibe:Vibe = world.vibe_nearby(cell)
	if vibe.get_element(Vibe.Element.Grass) >= 6:
		world.log("a gost posses a body")
		intend_transmute("res://DriftersUserDefined/waporwave/Peeple.tscn")
	
	if randf()<.01:
		intend_die()
	
func tweak():
	blabber("uuuuuuu...")

func blabber(words):
	var new_entry = message.instance()
	new_entry.message = words
	add_child(new_entry)
