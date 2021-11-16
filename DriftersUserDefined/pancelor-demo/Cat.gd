extends Drifter

var energy = 4

func _physics_process(_delta):
	._physics_process(_delta)
	position = lerp(position, target_position, 0.05)
	
# every so often
func evolve():
	var vibe = world.vibe_nearby(cell)
	var has_neighbors = vibe.get_guts() > 0
	if not has_neighbors and $WakeSprite.visible and energy <= 0:
		$SleepSprite.visible = true
		$WakeSprite.visible = false
	if has_neighbors:
		energy += 3
		$SleepSprite.visible = false
		$WakeSprite.visible = true
	
	if $WakeSprite.visible:
		if energy > 0:
			# move
			energy = clamp(energy-1,0,10)
			world.log("meow~")
			var dir = vibiest_dir(DirsAdjacent,{"Water":-2, "Guts":-0.05})
			if dir.x: $WakeSprite.flip_h = dir.x>0
			scale = Vector2(1.2,0.8)
			intend_move(dir)
		elif randf()*800<1:
			# clone, rarely
			world.log("meow!")
			intend_clone(DirsOrthogonal[randi()%4])

# when the player clicks
func tweak():
	world.log("meow~")
	if randf()*4<1:
		energy += 2
		$SleepSprite.visible = false
		$WakeSprite.visible = true
