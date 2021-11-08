extends Node2D

class_name GardenWorld

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	add_drifter( load("res://DriftersUserDefined/droqen-debug/BigSnail.tscn").instance(), Vector2(0,0) )

func reinitialize_drifters(drifters : Array):
	for drifter in drifters:
		initialize_drifter(drifter)

func add_drifter(drifter : Drifter, cell : Vector2):
	drifter.set_cell(cell)
	$DRIFTERS.add_child(drifter)
	initialize_drifter(drifter)
#	yield(drifter, "drifter_entered")
	# initialize drifter

func initialize_drifter(drifter : Drifter):
	drifter.target_position = $TileMap.map_to_world(drifter.cell)
	drifter.position = drifter.target_position

func _physics_process(_delta):
	for drifter in $DRIFTERS.get_children():
		if drifter.evolve_wait_frames <= 0 and randi() % 100 < drifter.evolve_percentage_chance:
			drifter.evolve_wait_frames = drifter.evolve_wait_after
			drifter.evolve(null)
	for drifter in $DRIFTERS.get_children():
		if drifter.has_intent():
			if drifter.intent_move:
				drifter.set_cell(drifter.cell + drifter.intent_move)
				drifter.target_position = $TileMap.map_to_world(drifter.cell)
			if drifter.intent_spawn_drifter:
				add_drifter(drifter.intent_spawn_drifter, drifter.cell + drifter.intent_spawn_dir)
			drifter.clear_intent()
	
	# check for collisions in a smarter way than this lol
	var drifters_to_remove = []
	for i in range($DRIFTERS.get_child_count()-1):
		var overlapping_drifters = []
		for j in range(i + 1, $DRIFTERS.get_child_count()):
			if $DRIFTERS.get_child(i).cell == $DRIFTERS.get_child(j).cell:
				overlapping_drifters.append($DRIFTERS.get_child(j))
		if overlapping_drifters:
			overlapping_drifters.append($DRIFTERS.get_child(i))
			overlapping_drifters.shuffle()
			var gutsiest_drifter = null
			var gutsiest_guts: int = 0
			for drifter in overlapping_drifters:
				if drifter.guts > gutsiest_guts:
					gutsiest_guts = drifter.guts
					gutsiest_drifter = drifter
			for drifter in overlapping_drifters:
				if drifter != gutsiest_drifter:
					free_after_20_frames(drifter)

func free_after_20_frames(drifter):
	yield(get_tree(),"idle_frame")
	if drifter.get_parent() == $DRIFTERS:
		$DRIFTERS.remove_child(drifter)
		$DEAD_DRIFTERS.add_child(drifter)
		yield(get_tree().create_timer(0.2),"timeout")
		drifter.free()
