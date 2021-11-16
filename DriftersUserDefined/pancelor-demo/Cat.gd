extends Drifter

func _physics_process(_delta):
	._physics_process(_delta)
	position = lerp(position, target_position, 0.05)
	
# every so often
func evolve():
	tweak()

# when the player clicks
func tweak():
	var vibe = world.vibe_nearby(cell)
	var has_neighbors = vibe.get_guts() > 0
	if not has_neighbors and $WakeSprite.visible:
		$SleepSprite.visible = true
		$WakeSprite.visible = false
	if $SleepSprite.visible and has_neighbors:
		$SleepSprite.visible = false
		$WakeSprite.visible = true
	if has_neighbors:
		var bad_dir = vibiest_dir(DirsAdjacent,{"Water":2, "Guts":0.05})
		var dir = -bad_dir
		if dir.x: $WakeSprite.flip_h = dir.x>0
		scale = Vector2(1.2,0.8)
		world.log("meow~")
		intend_move(dir)
	if randf()*600<1:
		world.log("meow!")
		intend_clone(DirsOrthogonal[randi()%4])
		
