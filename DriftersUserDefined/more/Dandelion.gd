extends Drifter

# Design+sprites by Linker
# Code by pancelor

# Dandelions (and seeds, which are probably more mobile than the actual plant)
# Probably major element grass, minor element wind? The seeds could move like
#   leaves do, but then if there's nothing around them they could plant themselves
# And if there's something nearby the puffball it could disperse seeds
# If there's fire close, they light on fire
# Or maybe they grow if there's gem, and disperse seeds if there's wind

var anim = 0.0
var ttl:float

onready var FLAMES = validated_drifter_path("res://DriftersUserDefined/pancelor-debug/Flames.tscn")

func _ready():
	scale = Vector2(1,0)

func _physics_process(delta):
	._physics_process(delta)

	anim += delta*2*PI
	var ds = sin(anim/2)/10
	target_scale = Vector2(1+ds, 1-ds)

func evolve():
	tweak()
func tweak():
	if $Sprite.frame == 0:
		# tuft
		var vibe = world.vibe_nearby(cell)
		if vibe.get_fire()>0 and randf()*3<1:
			intend_transmute(FLAMES)
		elif vibe.get_guts()<10 and randf()*12<1:
			$Sprite.frame = 1
			immovable = true
			world.log("a dandelion begins to grow")
		else:
			intend_move(vibiest_dir(DirsAdjacent,{"Guts":-0.02}))
	elif $Sprite.frame == 1:
		# sprout
		var vibe = world.vibe_nearby(cell)
		if (vibe.get_water()>3 or vibe.get_gem()>2) and randf()*3<1:
			$Sprite.frame=2
	elif $Sprite.frame == 2:
		# mature
		var vibe = world.vibe_nearby(cell)
		if (vibe.get_coal()>3 or vibe.get_gem()>6) and randf()*3<1:
			world.log("a dandelion begins to disperse")
			$Sprite.frame=3
			ttl = rand_range(5,10+1)
	elif $Sprite.frame == 3:
		# dying
		var vibe = world.vibe_nearby(cell)
		if vibe.get_wind()>1 and randf()*2<1:
			ttl -= 1
			if ttl < 0:
				$Sprite.frame=4
			else:
				intend_clone(DirsAdjacent[randi()%8])
	else:
		# dead
		if randf()*20<1:
			intend_die()
