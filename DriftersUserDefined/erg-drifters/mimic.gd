extends Drifter
# a mimic creature, which takes on the vibe of those around it as it's minor vibe,
# and attempts to mimic their sprites as well (without actual knowledge of anything other than vibes)
# seeks out fire vibes in order to crack it's shell and evolve into its true form
var trueForm=false
export(int) var fireNeeded; #how much fire is needed to hatch a mimic
export(int) var camoNeeded; #how much stuff needs to be around to spawn a new mimic
export(int) var trueFormSkipOdds
export(Texture)var WaterSprite;
export(Texture)var EarthSprite;
export(Texture)var GrassSprite;
export(Texture)var WindSprite;
export(Texture)var SandSprite;
export(Texture)var GemSprite;
export(Texture)var CoalSprite;
export(Texture)var TrueSprite;

onready var MIMIC = validated_drifter_path("res://DriftersUserDefined/erg-drifters/mimic.tscn")

#they dont mimic fire visually because i want the visual of any of their mimic forms bursting into true form
# every so often
func _ready():
	transform() # take up a mimic form right away

func transform():
	var vibe = world.vibe_nearby(cell)
	if(vibe.get_element(minor_element)-1<=0 || $Sprite.texture==TrueSprite): #subtracting one for our own contribution to said vibe
		#if nothing nearby is like you its time to mimic again
		#figure out the most popular element in the vibe
		var popularElement=Vibe.Element.Grass
		var highestVibe=0
		for i in vibe.elements.size():
			if(i!=Vibe.Element.Guts && i!=Vibe.Element.Fire):
				var elementVibe=vibe.elements[i]
				#exclude the mimics own element from the calculation (this is why i still am not using the built in one
				if(i==major_element):
					elementVibe-=3
				if(i==minor_element):
					elementVibe-=1
				if elementVibe>highestVibe:
					highestVibe=vibe.elements[i]
					popularElement = i
		minor_element=popularElement
#			print(minor_element)
		#now figure out which sprite to switch to based on that
		match minor_element:
			Vibe.Element.Water:
				$Sprite.texture=WaterSprite
			Vibe.Element.Earth:
				$Sprite.texture=EarthSprite
			Vibe.Element.Grass:
				$Sprite.texture=GrassSprite
			Vibe.Element.Wind:
				$Sprite.texture=WindSprite
			Vibe.Element.Sand:
				$Sprite.texture=SandSprite
			Vibe.Element.Gem:
				$Sprite.texture=GemSprite
			Vibe.Element.Coal:
				$Sprite.texture=CoalSprite
		#if the most popular element nearby is fire you wouldnt switch because fire is tracked seperately for evolving	
	
	if(vibe.get_fire()>fireNeeded):
		trueForm=true
		$Sprite.texture=TrueSprite
		minor_element=Vibe.Element.Gem
		world.log("A Mimic has emerged from it's shell.")
		evolve_skip_odds=trueFormSkipOdds #start moving way faster in true form
		guts=100 # stronger guts in true form
		$CPUParticles2D.emitting=true

func evolve():
	if(!trueForm):
		transform()
		#normally moves toward fire
		var dir
		dir = vibiest_dir(DirsAdjacent,{"Grass":0, "Fire":2, "Water": 0,"Coal":0,"Sand":0,"Wind":0,"Earth":0,"Guts":0})
		#if(world.vibe_nearby(cell+dir).get_fire()>0):
		intend_move(dir)
	else:
		#in mimic form it just rises
		intend_kill(Vector2.UP)
		intend_move(Vector2.UP)
		#should very occasionally reproduce on its own so the lifecycle makes sense
		var vibe = world.vibe_nearby(cell)
		#it should only spawn children if they are near things it's good at mimicking
		if(vibe.weight_by({"Grass":1, "Fire":-2, "Water": 2,"Coal":2,"Sand":2,"Wind":-2,"Earth":1,"Guts":0})>camoNeeded):
			intend_clone(DirsAdjacent[randi()%8])
			intend_clone(DirsAdjacent[randi()%8])
			intend_die()
			world.log("The Mimic spores multiply.")

# when the player clicks
func tweak():
	if(!trueForm):
		evolve()
		world.log("Strange behaviour...")
	else:
		intend_transmute(MIMIC)
		world.log("The Mimic retreats to it's shell")
