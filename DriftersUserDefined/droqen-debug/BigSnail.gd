extends Drifter

func _process(_delta):
	if randf()<0.02:
		$Sprite.scale = Vector2(1.1, 0.9)
	else:
		$Sprite.scale = lerp($Sprite.scale, Vector2(0.9, 1.1),0.02)

func evolve():
	var dir = DirsOrthogonal[randi()%4]
	$Sprite.scale = Vector2(1.2, 0.8)
	if dir.x: $Sprite.flip_h = dir.x < 0
	
	intent_move = dir
	intent_spawn_drifter = "res://DriftersUserDefined/droqen-debug/PoisonousGround.tscn"
	intent_spawn_dir = -dir # leave behind

func tweak():
	queue_free()
	
