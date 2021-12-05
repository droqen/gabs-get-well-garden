extends Drifter

func _ready():
	var blabites = ["mimi on","lonlo","mimon", "a a","li mon"]
	blabber(blabites[randi() % blabites.size()])

var anim = 0.0
var peeple = "res://DriftersUserDefined/waporwave/Peeple.tscn"
var mama = null
var abandonment = 30
var growuprate = .018
onready var message = load("res://DriftersUserDefined/waporwave/Blabber.tscn")

func _process(_delta):
	anim += _delta
	#if anim > 1:				realized i didn't need this, unless this could possibly overflow?
	#	anim = fmod(anim,1.0)
	$Sprite.scale = Vector2(1, 1+(sin((anim)*8*PI)/10))
	$Sprite.rotation_degrees = (sin(anim*4*PI))*10

func evolve():
	var dir = DirsOrthogonal[randi()%4]
	if not is_instance_valid(mama):
		mama=null

	if mama != null and randf()>.3:
		dir = ((mama.cell-cell).normalized()).round()
	else:
		for direction in DirsOrthogonal:
			var tile = world._get_drifter_at_cell(cell+direction)
			var tile_type = null
			if tile == null: tile_type = ""
			else: tile_type = tile.get_filename()
			if tile_type == peeple:
				mama = tile
		if mama == null:
			abandonment -= 1
			if randf()<.3:
				blabber("mama?")
			if abandonment <= 0:
				world.log("a peeplet is abandoned")
				intend_transmute("res://DriftersUserDefined/waporwave/Peeple_Remains.tscn")
		else:
			abandonment = 30


	var unto = world._get_drifter_at_cell(cell+dir)
	if unto == null: unto = ""
	else: unto = unto.get_filename()

	if unto != _my_own_path and unto != peeple:
		intend_spawn("res://DriftersUserDefined/waporwave/Path.tscn",Vector2.ZERO)
		intend_move(dir)

	if randf()<growuprate:
		intend_transmute(peeple)

	if randf()<.1:
		blabber("wa")

	var vibe:Vibe = world.vibe_nearby(cell)
	if vibe.get_element(Vibe.Element.Fire) >= 6:
		world.log("a peeple passes") #overheating
		intend_transmute("res://DriftersUserDefined/waporwave/Peeple_Remains.tscn")
	if vibe.get_element(Vibe.Element.Coal) >= 4 or vibe.get_element(Vibe.Element.Gem) >= 3:
		world.log("a peeple passes") #poisoning
		intend_transmute("res://DriftersUserDefined/waporwave/Peeple_Remains.tscn")
	if vibe.get_element(Vibe.Element.Grass) >= 15:
		world.log("a peeple passes") #overcrowding
		intend_transmute("res://DriftersUserDefined/waporwave/Peeple_Remains.tscn")

func tweak():
	blabber("a")

func blabber(words):
	var new_entry = message.instance()
	new_entry.message = words
	add_child(new_entry)
