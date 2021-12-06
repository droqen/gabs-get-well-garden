extends Drifter

onready var ttl:int = rand_range(5,12+1)
onready var mating_weights = Vibe.new({
	"Fire":2,
	"Water":2,
	"Earth":-1,
	"Grass":-1,
	"Wind":1,
	"Sand":2,
	"Gem":-1,
	"Coal":-5,
})
onready var RIVER = validated_drifter_path("res://DriftersUserDefined/pancelor-debug/River.tscn")

func _physics_process(_delta):
	._physics_process(_delta) # call method on base class
	if randf()*50<1:
		scale.x *= 1.1
		scale.y *= 0.9
		rotation_degrees = rand_range(-10,10)

func evolve():
	tweak()
	
func tweak():
	ttl -= 1
	var mate_score = world.vibe_nearby(cell).weight_by(mating_weights)
#	print("mate_score ",mate_score)
	if ttl < 0:
		world.log("a fish takes its rest")
		intend_transmute(RIVER)
	elif mate_score>=14 and mate_score<=20 and randf()*4<1:
		intend_clone(vibiest_dir(DirsOrthogonal,{"Guts":-0.1}))
		world.log("a fish is born")
	else:
		var weights = {"Guts":-1}
		if randf()*3<1:
			# move towards rivers occasionally
			weights = {"Water":3, "Wind":2, "Guts":-0.01}

		var dir = vibiest_dir(DirsOrthogonal,weights)
		scale = Vector2(1.2, 0.8)
		if dir.x: $Sprite.flip_h = dir.x<0
		rotation_degrees = rand_range(-20,20)
		intend_move_and_leave(dir,RIVER)
