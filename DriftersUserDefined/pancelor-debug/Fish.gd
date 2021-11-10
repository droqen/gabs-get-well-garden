extends Drifter

onready var ttl:int = rand_range(10,20)
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

func _ready():
	world.log("a fish is born")

func _process(_delta):
	if randf()*50<1:
		scale = Vector2(1.2,0.8)
		rotation_degrees = rand_range(-10,10)
	else:
		scale = lerp(scale,Vector2(1.0,1.0),0.02)
		rotation_degrees = lerp(rotation_degrees,0,0.02)

func evolve():
	tweak()
	
func tweak():
	ttl -= 1
	if ttl <= 0:
		world.log("a fish takes its rest")
		intend_transmute("res://DriftersUserDefined/pancelor-debug/River.tscn")
	elif world.vibe_nearby(cell).weight_by(mating_weights)>10 and randf()*5<1:
		intend_spawn("res://DriftersUserDefined/pancelor-debug/Fish.tscn", vibiest_dir(DirsOrthogonal,{"Guts":-0.01}))
	else:
		var weights = {"Guts":-1}
		if randf()*2<1:
			# move towards rivers occasionally
			weights = {"Water":3, "Wind":2, "Guts":-0.01}

		var dir = vibiest_dir(DirsOrthogonal,weights)
		scale = Vector2(1,1) + dir*0.3
		rotation_degrees = rand_range(-20,20)
		intend_move_and_leave(dir,"res://DriftersUserDefined/pancelor-debug/River.tscn")
