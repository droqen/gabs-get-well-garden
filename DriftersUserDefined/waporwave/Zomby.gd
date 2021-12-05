extends Drifter

func _ready():
	blabber("waaaaa")
	world.log("zombys spread")

var anim = 0.0
onready var message = load("res://DriftersUserDefined/waporwave/Blabber.tscn")

func _process(_delta):
	anim += _delta
	$Sprite.scale = Vector2(1, 1+(sin((anim)*1.2*PI)/10))
	$Sprite.rotation_degrees = (sin(anim*.6*PI))*10

func evolve():
	if randf()<.2:
		var blabites = ["waaa...","lawa...","mm wil.. moku..."]
		blabber(blabites[randi() % blabites.size()])
	
	var dir = vibiest_dir(DirsAdjacent,{"Grass":1})
	intend_move(dir)
	
	var vibe:Vibe = world.vibe_nearby(cell)
	
	if vibe.get_element(Vibe.Element.Grass) >= 2:
		intend_spawn("res://DriftersUserDefined/waporwave/Zomby.tscn",vibiest_dir(DirsAdjacent,{"Grass":1}))
	
	if randf()<.08:
		world.log("a zomby returns to the earth") #nofoodidk
		intend_transmute("res://DriftersUserDefined/waporwave/Tombstone.tscn")
	
	#unnatural deaths
	if vibe.get_element(Vibe.Element.Fire) >= 4:
		world.log("a zomby returns to the earth") #overheating
		intend_transmute("res://DriftersUserDefined/waporwave/Tombstone.tscn")
	if vibe.get_element(Vibe.Element.Gem) >= 4:
		world.log("a zomby returns to the earth") #magic?
		intend_transmute("res://DriftersUserDefined/waporwave/Tombstone.tscn")
	
func tweak():
	intend_spawn("res://DriftersUserDefined/waporwave/Zomby.tscn",vibiest_dir(DirsAdjacent,{"Grass":1}))

func blabber(words):
	var new_entry = message.instance()
	new_entry.message = words
	add_child(new_entry)
