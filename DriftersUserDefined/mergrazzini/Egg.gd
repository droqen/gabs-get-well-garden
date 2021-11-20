extends Drifter

var shakes_left = rand_range(3,5+1)

onready var DRAGON = validated_drifter_path("res://DriftersUserDefined/mergrazzini/Dragon.tscn")

func _physics_process(_delta):
	._physics_process(_delta) # call method on base class
	if scale.is_equal_approx(target_scale):
		$NavdiSheetSprite.frames = [2]

func evolve():
	if $FriedSprite.visible: return
	
	var vibe = world.vibe_nearby(cell)
	if vibe.get_element("Fire") > 5 and randf()*2<1:
		#If there are a couple Fire around, the Egg gets fried
		world.log("Something smells delicious")
		$FriedSprite.visible = true
		$NavdiSheetSprite.visible = false
	elif vibe.get_element("Water") > 2 and randf()*10<1:
		#If there are enough Water around, the egg hatches and transmutes into a Dragon
		tweak()

func tweak():
	if $FriedSprite.visible:
		scale *= Vector2(1.6,1.3)
		rotation_degrees = rand_range(-20,20)
		if randf()*8 < 1:
			intend_die()
	else:
		shakes_left -= 1
		if shakes_left < 0:
			# hatch!
			world.log("A new life has spawned")
			intend_transmute(DRAGON)
		else:
			# shake
			$NavdiSheetSprite.frames = [3,4,3,3,4,4]
			$NavdiSheetSprite.frame = 3
			scale *= Vector2(1.3,1.6)
			rotation_degrees = rand_range(-20,20)
