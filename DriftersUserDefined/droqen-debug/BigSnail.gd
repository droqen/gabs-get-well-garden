extends Drifter

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if randf()<0.02:
		$Sprite.scale = Vector2(1.1, 0.9)
	else:
		$Sprite.scale = lerp($Sprite.scale, Vector2(0.9, 1.1),0.02)

func evolve(vibe:Vibe):
	var dir = DirsOrthogonal[randi()%4]
	$Sprite.scale = Vector2(1.2, 0.8)
	if dir.x: $Sprite.flip_h = dir.x < 0
	
	intent_move = dir
	intent_spawn_drifter = load("res://DriftersUserDefined/droqen-debug/PoisonousGround.tscn").instance()
	intent_spawn_dir = -dir # leave behind
