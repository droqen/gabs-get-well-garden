extends Drifter

# Design by Pinchazumos + pancelor
# Sprite by pancelor
# Code by pancelor

var pumps = rand_range(4,6+1)

onready var EGG = validated_drifter_path("res://DriftersUserDefined/Milkman/Egg.tscn")

func _ready():
	scale = Vector2(1,0)
	target_scale = Vector2(0.7,0.7)

func _physics_process(delta):
	._physics_process(delta)
	if randf()*120<1:
		scale = Vector2(rand_range(0.7,0.9),rand_range(0.5,0.7))

func evolve():
	pumps -= 1
	if pumps < 0:
		world.log("the fungal biome spreads its roots")
		intend_clone(DirsAdjacent[randi()%8])
		intend_clone(DirsAdjacent[randi()%8])
		if randf()*200<1:
			intend_transmute(EGG)
		else:
			intend_die()
	else:
		# grow nearby drifters (but not gem, like mushrooms themselves)
		var dir = vibiest_dir(DirsOrthogonal,{"Guts":0.05,"Gem":-2})
		var drifter = world._get_drifter_at_cell(cell+dir)
		if drifter:
			drifter.target_scale += Vector2(0.1,0.1)
			pumps -= 1
	
func tweak():
	evolve()
