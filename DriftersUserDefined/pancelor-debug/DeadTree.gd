extends Drifter

onready var FLAMES = validated_drifter_path("res://DriftersUserDefined/pancelor-debug/Flames.tscn")
onready var MUSHROOM = validated_drifter_path("res://DriftersUserDefined/more/Mushroom.tscn")

func _ready():
	target_scale = Vector2(1,rand_range(0.8,1.3))
	# also, don't set scale to 0

func evolve():
	var vibe:Vibe = world.vibe_nearby(cell)
	if vibe.get_fire() > 2:
		world.log("a dead tree bursts into flames")
		intend_transmute(FLAMES)
	elif randf()*100 < 1:
		tweak()

# die
func tweak():
	if randf()*60<1:
		world.log("the gnarled roots reveal a mushroom")
		intend_transmute(MUSHROOM)
	else:
		target_rotation_degrees = 90
		intend_die()
