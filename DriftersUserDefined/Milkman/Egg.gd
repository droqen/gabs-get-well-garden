extends Drifter

var anim = 0.0
var age = 0

onready var SNAKE = validated_drifter_path("res://DriftersUserDefined/Milkman/Snake.tscn")
onready var DRAGON = validated_drifter_path("res://DriftersUserDefined/mergrazzini/Dragon.tscn")

func _ready():
	scale = Vector2(1,0)

func _physics_process(delta):
	._physics_process(delta)

	anim += delta
	target_scale = Vector2(1, 1+(sin((anim)*4*PI)/10))
	rotation_degrees = (sin(anim*2*PI))*10
	
# every so often
func evolve():
	tweak()

func tweak():
	age += 1
	if age >5:
		age = 0
		if randf()*20<1:
			intend_transmute(DRAGON)
			world.log("The egg hatches into... a dragon??")
		else:
			intend_transmute(SNAKE)
			world.log("The egg hatches into a brand new snake")
