extends Drifter


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
#func _ready():
#	$CPUParticles2D.preprocess = randf()
#	$CPUParticles2D.restart()

func evolve():
	intent_spawn_drifter = "res://DriftersUserDefined/droqen-debug/BigSnail.tscn"
	intent_spawn_dir = Vector2.ZERO

func tweak():
	queue_free()
	
