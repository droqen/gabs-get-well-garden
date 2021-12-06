extends Drifter

onready var FISH = validated_drifter_path("res://DriftersUserDefined/pancelor-debug/Fish.tscn")
onready var DRAGONSNAIL = validated_drifter_path("res://DriftersUserDefined/mergrazzini/DragonSnail.tscn")

# every so often
func evolve():
	tweak()

# when the player clicks
func tweak():
	if randf()*40<1:
		intend_transmute(FISH)
	if randf()*100<1:
		intend_transmute(DRAGONSNAIL)
	elif randf()*20<1:
		intend_die()
