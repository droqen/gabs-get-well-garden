extends Drifter

var ammo:int = 10

# every so often
func evolve():
	#I'm copying the code for max vibe at and nearby because I want them combined
	var dir = null
	var best_score = 0
	var weight1 = {"Water":1, "Earth":-1} #nearby
	var weight2 = {"Earth":-5, "Guts":-0.01} #at
	for dcell in DirsAdjacent:
		var score = world.vibe_nearby(cell+dcell).weight_by(weight1) + world.vibe_at(cell+dcell).weight_by(weight2) + randf()
		if not dir or score > best_score:
			dir = dcell
			best_score = score
			
	if(ammo > 0):
		intend_move_and_leave(dir,"res://DriftersUserDefined/mokesmoe/Wire.tscn")
		ammo -= 1
		if(ammo <= 0):
			world.log("the wiremaker runs dry")
	elif(randf()*2<1):
		intend_move(dir)
	var vibe = world.vibe_nearby(cell)
	if(vibe.get_water() > 3 && randf()*10<1):
		tweak()
		
# when the player clicks
func tweak():
	ammo = 10
	world.log("the wiremaker restocks")
