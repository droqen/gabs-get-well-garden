extends Drifter

onready var ttl:int = rand_range(20,40+1)
	
func _physics_process(_delta):
	._physics_process(_delta) # call method on base class
	if randf()*50<1:
		scale = Vector2(1.1,0.9)
		
func evolve():
	var emptydir = vibiest_dir(DirsAdjacent,{"Guts":-0.02})
	var vibe = world.vibe_nearby(cell)
	if vibe.get_wind() > 3 and randf()*20<1:
		#Spawn an egg!!
		world.log("Can you feel the love tonight?")
		intend_spawn("res://DriftersUserDefined/mergrazzini/Egg.tscn", emptydir)
	elif vibe.get_gem() > 3 and randf()*20<1:
		#Spawn an Dragonsnail!!
		world.log("Voulez-vous coucher avec moi, ce soir?")
		intend_spawn("res://DriftersUserDefined/mergrazzini/DragonSnail.tscn", emptydir)
	else:
		ttl -= 1
		if ttl < 0:
			world.log("A mighty creature returns to ashes")
			intend_transmute("res://DriftersUserDefined/pancelor-debug/Flames.tscn")
		else:
			# move towards Wind but away from guts:
			var dir = vibiest_dir(DirsAdjacent,{"Wind":1, "Guts":-0.02})
			if dir.x: $NavdiSheetSprite.flip_h = dir.x<0
			scale = Vector2(1.2, 0.8)
			intend_move(dir)
			if randf()*6<1: intend_spawn("res://DriftersUserDefined/pancelor-debug/Flames.tscn", dir+Vector2(-dir.y,dir.x))
			if randf()*6<1:	intend_spawn("res://DriftersUserDefined/pancelor-debug/Flames.tscn", dir+Vector2(dir.y,-dir.x))

func tweak():
	var emptydir = vibiest_dir(DirsAdjacent,{"Guts":-0.02})
	intend_spawn("res://DriftersUserDefined/pancelor-debug/Flames.tscn", emptydir)
