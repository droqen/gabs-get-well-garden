extends Drifter

onready var ttl:int = rand_range(10,30+1)

onready var RIVER = validated_drifter_path("res://DriftersUserDefined/pancelor-debug/River.tscn")

func _physics_process(_delta):
	._physics_process(_delta) # call method on base class
	if position.is_equal_approx(target_position):
		$NavdiSheetSprite.frames = [7]
	if randf()*50<1:
		scale = Vector2(1.1,0.9)
		
# every so often
func evolve():
	ttl -= 1
	if ttl < 0:
		world.log("Glupppppp")
		intend_transmute(RIVER)
	else:
		var dir = DirsAdjacent[randi()%4]
		# move towards Grass but away from Coal:
		if randf()*2<1:
			dir = vibiest_dir(DirsAdjacent,{"Grass":3, "Coal":-1})
		if dir.x: $NavdiSheetSprite.flip_h = dir.x<0
		scale = Vector2(1.2, 0.8)
		$NavdiSheetSprite.frames = [6,7]
		$NavdiSheetSprite.frame = 6
		intend_move(dir)
		if randf()*6<1: intend_spawn(RIVER, dir+Vector2(-dir.y,dir.x))
		if randf()*6<1:	intend_spawn(RIVER, dir+Vector2(dir.y,-dir.x))

# when the player clicks
func tweak():
	#Spawns water
	world.log("Glup glup glup")
	var emptydir = vibiest_dir(DirsAdjacent,{"Guts":-0.02})
	intend_spawn(RIVER, emptydir)
