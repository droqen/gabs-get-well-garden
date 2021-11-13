extends Drifter

var isVisible = true

var emitIce = false


func _ready():
	tweak()

var doSpawn = false
func evolve():
	if doSpawn:
		doSpawn = false
		for dir in DirsAdjacent:
			intend_spawn("res://DriftersUserDefined/jack/ice.tscn", dir)
			intend_spawn("res://DriftersUserDefined/jack/ice.tscn", dir*2)
		intend_transmute("res://DriftersUserDefined/jack/tower.tscn")
		world.log("??? ?!?!?!")
	
	
	
	if isVisible:
		if randi()%200 == 0 and not charging:
			isVisible = false
			intend_spawn("res://DriftersUserDefined/jack/dust.tscn", DirsOrthogonal[randi()%4])
	else:
		if randi()%1000 == 0:
			isVisible = true
			
	
	var test = randi()%180
#	if not emitIce and test == 0:
#		emitIce = true
#		$IceTimer.start()
	
	#var dir = vibiest_dir(DirsAdjacent,{"Wind":1, "Guts":-2})
	
	#if emitIce:
	#	for dir in DirsAdjacent:		
	#		intend_spawn_at("res://DriftersUserDefined/jack/ice.tscn", cell + dir)
	
	test = randi()%299
	var vibe:Vibe = world.vibe_nearby(cell)
	if vibe.get_sand()>=1 and not charging and test == 0:
		isVisible = true
		var fireDir = vibiest_dir(DirsAdjacent, {"Sand":3})
		intend_move(fireDir)
	
	if vibe.get_coal() > 0:
		stopCharging()
	
	test = randi()%99
	if test == 0 and not charging:		
		var size = 3
		var dest = Vector2(randi()%size-size/2,randi()%size-size/2)
		intend_spawn("res://DriftersUserDefined/jack/dust.tscn", Vector2())
		intend_move(dest)
		
	test = randi()%300
	if vibe.get_grass() > 0 and vibe.get_coal() == 0 and test == 0 and not charging:
		tweak()
		world.log("??? starts to ???")
		startCharging()
		
		
	$AnimatedSprite.visible = isVisible or charging

var charging = false
func startCharging():
	charging = true
	$AnimatedSprite.speed_scale = 4
	$CPUParticles2D.emitting = true
	$IceTimer.start()
	
func stopCharging():
	if charging:
		charging = false
		$AnimatedSprite.speed_scale = 1
		$CPUParticles2D.emitting = false
		$IceTimer.stop()

func finishCharging():
	stopCharging()
	tweak()
	doSpawn = true
	

func tweak():
	#intend_spawn(_my_own_path,DirsOrthogonal[randi()%4])
	#print(world.vibe_nearby(cell))
	var key = randi()%4
	match key:
		0:
			$AnimatedSprite.play("red")
		1:
			$AnimatedSprite.play("green")
		2:
			$AnimatedSprite.play("orange")
		3:
			$AnimatedSprite.play("purple")
	pass


func _on_IceTimer_timeout():
	finishCharging()
	$IceTimer.stop()
