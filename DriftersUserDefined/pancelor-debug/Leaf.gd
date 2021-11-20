extends Drifter

var repeat_dir:bool
var dir:Vector2

onready var FLAMES = validated_drifter_path("res://DriftersUserDefined/pancelor-debug/Flames.tscn")
onready var WHIRLWIND = validated_drifter_path("res://DriftersUserDefined/pancelor-demo/Whirlwind.tscn")
onready var SAPLING = validated_drifter_path("res://DriftersUserDefined/pancelor-debug/Sapling.tscn")

func _physics_process(_delta):
	._physics_process(_delta) # call method on base class
	if randf()*50<1:
		scale = Vector2(1.1, 0.9)
		rotation_degrees = rand_range(-20,20)

func evolve():
	var vibe:Vibe = world.vibe_nearby(cell)
	if vibe.get_fire() > 1:
		world.log("a wandering leaf bursts into flames")
		intend_transmute(FLAMES)
	elif vibe.get_wind() > 6:
		world.log("many leaves join forces")
		intend_transmute(WHIRLWIND)
	elif randf()*50<1:
		# settle
		tweak()
	else:
		if not repeat_dir:
			dir = vibiest_dir(DirsAdjacent,{"Wind":1,"Earth":-1})
		repeat_dir = not repeat_dir

		scale = Vector2(1.2, 0.8)
		if dir.x: $Sprite.flip_h = dir.x<0
		
		intend_move(dir)

func tweak():
	if randf()*3<1:
		world.log("a leaf settles down")
		intend_transmute(SAPLING)
	else:
		intend_die()
