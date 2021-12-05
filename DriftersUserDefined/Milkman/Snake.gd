extends Drifter

var anim = 0.0
var ttl = rand_range(20,40+1)
var eggs = rand_range(1,2+1)

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
	var should_lay = false
	ttl-=1
	if ttl<0:
		eggs -= 1
		if eggs < 0:
			intend_die()
			return
		else:
			should_lay = true
			world.log("The snake lays an egg")
			ttl = rand_range(20,40+1)
	var dir = DirsOrthogonal[randi()%4]
	scale = Vector2(1.2, 0.8)
	if dir.x: $Sprite.flip_h = dir.x < 0
	if should_lay:
		intend_move_and_leave(dir,EGG)
	else:
		intend_move(dir)
