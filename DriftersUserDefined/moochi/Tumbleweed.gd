extends Drifter

export var max_rotation_deg = 30;
export var max_life = 50;
export var life_per_leaf = 15;
var life = 0

onready var LEAF = validated_drifter_path("res://DriftersUserDefined/pancelor-debug/Leaf.tscn")

var anim:float = 0.0

var base_rotation_deg = 0
var last_direction = 1

func _physics_process(_delta):
	._physics_process(_delta) # call method on base class 
	anim += _delta*2*PI
	scale = Vector2.ONE + ((max_life-life)/max_life * rand_range(0.7, 1.2)) * Vector2.UP
	
	rotation_degrees -= last_direction * 0.1 * anim	

func evolve():
	tweak()
	
func tweak():
	var wind_dir = vibiest_dir(DirsOrthogonal, Vibe.new({
		"Wind": -10
	}))

	var life_delta = randi() % 3
	var drop_leaf = false
	for i in range(0, life_delta):
		life += 1
		if life % life_per_leaf == 0:
			drop_leaf = true
	
	if drop_leaf:
		intend_move_and_leave(wind_dir, LEAF)
		world.log("a tumbleweed tumbles")
	else:
		intend_move(wind_dir)

	if life >= max_life:
		for dir in DirsOrthogonal:
			intend_spawn(LEAF, dir)
		intend_die()
	# .rotated((randf() - 0.5) * 2 * deg2rad(max_rotation_deg))

	if abs(wind_dir.x) > 0:
		last_direction = wind_dir.x
#	print("mate_score ",mate_score)
