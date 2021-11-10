extends Drifter

var ttl:int

func _init():
	ttl = rand_range(5,10)
	ttl = rand_range(1,3)

func _process(_delta):
	if randf()*50<1:
		$Sprite.scale = Vector2(1.1, 0.9)
	else:
		$Sprite.scale = lerp($Sprite.scale, Vector2(0.9, 1.1),0.02)

func evolve():
	ttl -= 1
	if ttl <= 0:
		world.log("a snail moves on")
		intend_die()
	else:
		var dir = DirsOrthogonal[randi()%4]
		$Sprite.scale = Vector2(1.2, 0.8)
		if dir.x: $Sprite.flip_h = dir.x < 0
		
		intend_move(dir)
		intend_spawn("res://DriftersUserDefined/droqen-debug/PoisonousGround.tscn",Vector2.ZERO) # leave posion behind

func tweak():
	queue_free()
