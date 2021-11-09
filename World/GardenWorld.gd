extends Node2D

var drifter_dictionary:Dictionary = {}

func cellkey(cell):
	return cell.x+10000*cell.y
func register(d):
	if d.__registered: return
	if not drifter_dictionary.has(cellkey(d.cell)):
		drifter_dictionary[cellkey(d.cell)] = [d]
	else:
		drifter_dictionary[cellkey(d.cell)].append(d)
	d.__registered = true
func unregister(d):
	if not d.__registered: return
	drifter_dictionary[cellkey(d.cell)].erase(d)
	d.__registered = false
func _get_drifter_at_cell(cell : Vector2):
	if drifter_dictionary.has(cellkey(cell)):
		if drifter_dictionary[cellkey(cell)]:
			return drifter_dictionary[cellkey(cell)][0]
	return null

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	# debug:
	add_drifter( "res://DriftersUserDefined/droqen-debug/BigSnail.tscn", Vector2(-2,-2) )
	add_drifter( "res://DriftersUserDefined/pancelor-debug/Tree.tscn", Vector2(2,2) )
	add_drifter( "res://DriftersUserDefined/pancelor-debug/Tree.tscn", Vector2(4,7) )
	add_drifter( "res://DriftersUserDefined/pancelor-debug/Tree.tscn", Vector2(6,1) )
	
	$cell_cursor.connect("clicked_cell", self, "_on_clicked_cell")
	
func _on_clicked_cell(cell : Vector2):
	var drifter = _get_drifter_at_cell(cell)
	if drifter:
		drifter.tweak(null)
	else:
		# add a completely random thingy.
		add_drifter("res://DriftersUserDefined/droqen-debug/BigSnail.tscn", cell )

func reinitialize_drifters(drifters : Array):
	for drifter in drifters:
		initialize_drifter(drifter)

func add_drifter(drifter_path : String, cell : Vector2):
	var drifter = load(drifter_path).instance()
	drifter._my_own_path = drifter_path
	_add_drifter_node(drifter, cell)
func _add_drifter_node(drifter : Drifter, cell : Vector2):
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
		if drifter.evolve_wait_frames <= 0 and randf()*drifter.evolve_skip_odds<1:
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
	
	for key in drifter_dictionary:
		var overlapping_drifters = drifter_dictionary[key]
		if len(overlapping_drifters) > 1:
			print("Overlapping at ",key)
			for drifter in overlapping_drifters:
				var percent = drifter.guts/100.0
				drifter._todays_guts = randf()*percent*percent
				print(" guts: ",percent," today: ",drifter._todays_guts," (",drifter._my_own_path,")")
			var gutsiest_drifter = null
			var gutsiest_guts: int = 0
			for drifter in overlapping_drifters:
				if drifter._todays_guts > gutsiest_guts:
					gutsiest_guts = drifter._todays_guts
					gutsiest_drifter = drifter
			print(" winner: ",gutsiest_drifter._my_own_path)
			for drifter in overlapping_drifters:
				if drifter != gutsiest_drifter:
					_free_after_20_frames(drifter)

func _free_after_20_frames(drifter):
	yield(get_tree(),"idle_frame")
	if drifter.get_parent() == $DRIFTERS:
		$DRIFTERS.remove_child(drifter)
		drifter.dead = true
		$DEAD_DRIFTERS.add_child(drifter)
		yield(get_tree().create_timer(0.2),"timeout")
		drifter.queue_free()

#
# useful things drifters can call:
#

func vibe_nearby(cell:Vector2):
	var vibe = Vibe.new()
	for dy in range(-1,2):
		for dx in range(-1,2):
			var drifter = _get_drifter_at_cell(cell+Vector2(dx,dy))
			vibe._add_element(drifter.major_aspect,3)
			vibe._add_element(drifter.minor_aspect,1)
			vibe._add_element(Elemental.GUTS, drifter.guts)
	return vibe
