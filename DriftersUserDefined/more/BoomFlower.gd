extends Drifter

var anim = 0.0

onready var FLAMES = validated_drifter_path("res://DriftersUserDefined/pancelor-debug/Flames.tscn")

func _ready():
	scale = Vector2(1,0)
	
func _physics_process(delta):
	._physics_process(delta)

	anim += delta*2*PI
	target_rotation_degrees = sin(anim/2)*10
	scale = Vector2(1,1) # don't disappear when dying

func evolve():
	var vibe = world.vibe_nearby(cell)
	if vibe.get_fire()>8:
		tweak()

func tweak():
	$NavdiBitsySprite.frames=[2,3,4,5,6]
	$NavdiBitsySprite.frame_period=5
	intend_die()
	for i in range(0,3):
		intend_spawn(FLAMES,DirsAdjacent[randi()%8])
	
