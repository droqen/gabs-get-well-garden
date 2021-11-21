extends Drifter

# Finds some grass to sleep
onready var sleepTimer_reset = 10
onready var sleepTimer = 10

onready var state = 0

func _ready():
	$AnimatedSprite.play('default')

func evolve():
	tweak()

func tweak():
	var vibe = world.vibe_nearby(cell);
	if vibe.get_grass() < 1:
		sleepTimer = sleepTimer_reset
		if state != 1:
			state = 1
			$AnimatedSprite.play('walk')
		var dir = vibiest_dir(DirsOrthogonal,{"Grass":1})
		if dir.x: $AnimatedSprite.flip_h = dir.x<0
		intend_move(dir)
	elif sleepTimer > 0:
		if state != 0:
			state = 0
			$AnimatedSprite.play('default')
		sleepTimer -= 1
	elif state != 2:
		state = 2
		$AnimatedSprite.play('sleep')
