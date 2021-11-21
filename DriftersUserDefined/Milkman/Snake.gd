extends Drifter

var anim = 0.0
var age = 0

onready var EGG = validated_drifter_path("res://DriftersUserDefined/Milkman/Egg.tscn")

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
	var dir = DirsOrthogonal[randi()%4]
	scale = Vector2(1.2, 0.8)
	if dir.x: $Sprite.flip_h = dir.x < 0

	intend_move(dir)
	age += 1
	if age >10:
		intend_spawn(EGG, Vector2(0,0))
		world.log("The snake lays an egg")
		age = 0
