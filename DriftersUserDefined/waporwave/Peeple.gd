extends Drifter

func _ready():
	blabber("mi lon")

var anim = 0.0
var peeplet = "res://DriftersUserDefined/waporwave/Peeplet.tscn"
var birthrate = .05
var deathrate = .007
onready var message = load("res://DriftersUserDefined/waporwave/Blabber.tscn")

func _process(_delta):
	anim += _delta
	$Sprite.scale = Vector2(1, 1+(sin((anim)*4*PI)/10))
	$Sprite.rotation_degrees = (sin(anim*2*PI))*10

func evolve():
	if randf()<.1:
		for direction in DirsAdjacent:
			var tile = world._get_drifter_at_cell(cell+direction)
			if tile != null:
				var blabites = ["mi pali","mi ante e ni","o ante"]
				blabber(blabites[randi() % blabites.size()])
				tile.tweak()
				break
	
	var dir = vibiest_dir(DirsAdjacent,{"Earth":1})
	if randf()>.4 and world.vibe_at(cell+dir).get_element(Vibe.Element.Earth) >= 3:
		if randf()>.25:
			dir = -dir
		else:
			dir = DirsOrthogonal[randi()%4]
	
	var unto = world._get_drifter_at_cell(cell+dir)
	if unto == null: unto = "" 
	else: unto = unto.get_filename()
	
	if unto != _my_own_path and unto != peeplet:
		intend_spawn("res://DriftersUserDefined/waporwave/Path.tscn",Vector2.ZERO)
		intend_spawn("res://DriftersUserDefined/waporwave/Path.tscn",DirsOrthogonal[randi()%4])
		intend_move(dir)
		if randf()<.1:
			var blabites = ["mi tawa","mi pali e nasin","mi tawa lon nasin"]
			blabber(blabites[randi() % blabites.size()])
	
	var vibe:Vibe = world.vibe_nearby(cell)
	
	if randf()<birthrate:
		var blabites = ["o kama pona","jan lili o, kama lon","sina pona mi","o awen lon pi poka mi"]
		blabber(blabites[randi() % blabites.size()])
		birth()
	if randf()<deathrate:
		world.log("a peeple passes") #natural causes
		intend_transmute("res://DriftersUserDefined/waporwave/Peeple_Remains.tscn")
	
	
	#unnatural deaths
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
	var blabites = ["a","seme?","mi pilin ante","ni li jan sewi?"]
	blabber(blabites[randi() % blabites.size()])
	birth()

func blabber(words):
	var new_entry = message.instance()
	new_entry.message = words
	add_child(new_entry)

func birth():
	intend_spawn(peeplet,DirsOrthogonal[randi()%4])
