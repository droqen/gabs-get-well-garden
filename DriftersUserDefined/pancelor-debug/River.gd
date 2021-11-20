extends Drifter

onready var FISH = validated_drifter_path("res://DriftersUserDefined/pancelor-debug/Fish.tscn")

# every so often
func evolve():
	tweak()

# when the player clicks
func tweak():
	if randf()*20<1:
		intend_transmute(FISH)
	elif randf()*20<1:
		intend_die()
