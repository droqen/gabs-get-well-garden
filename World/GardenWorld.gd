extends Node2D

export(Array, PackedScene)var spawnables:Array

var drifter_dictionary:Dictionary = {}

func cellkey(cell:Vector2):
	return cell.x+10000*cell.y
func register(d:Drifter):
	if d.__registered or d.get_parent() != $DRIFTERS: return
	if not drifter_dictionary.has(cellkey(d.cell)):
		drifter_dictionary[cellkey(d.cell)] = [d]
	else:
		drifter_dictionary[cellkey(d.cell)].append(d)
	d.__registered = true
func unregister(d:Drifter):
	if not d.__registered: return
	drifter_dictionary[cellkey(d.cell)].erase(d)
	d.__registered = false
func reregister(d:Drifter,newcell:Vector2):
	unregister(d)
	d._rawset_cell(newcell)
	register(d)
func _get_drifter_at_cell(cell : Vector2):
	if drifter_dictionary.has(cellkey(cell)):
		if drifter_dictionary[cellkey(cell)]:
			return drifter_dictionary[cellkey(cell)][0]
	return null

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$cell_cursor.connect("clicked_cell", self, "_on_clicked_cell")

	# debug:
	for packed_drifter in spawnables:
		_add_drifter( packed_drifter.resource_path, Vector2(int(rand_range(-7,7+1)), int(rand_range(-6,6+1))) )

func _on_clicked_cell(cell : Vector2, button : int):
	if button == BUTTON_LEFT:
		_clicked = true
		_clicked_cell = cell
	elif button == BUTTON_RIGHT:
		# debug: print out vibe
		var vibe = vibe_at(cell)
		print("")
		print("vibe_at",cell,"=\n\t",vibe.to_string(),"\n\tmax=",vibe.max_element(),", min=",vibe.min_element())
		vibe = vibe_nearby(cell)
		print("vibe_nearby",cell,"=\n\t",vibe.to_string(),"\n\tmax=",vibe.max_element(),", min=",vibe.min_element())
		
func reinitialize_drifters(drifters : Array):
	for drifter in drifters:
		_initialize_drifter(drifter)

func _add_drifter(drifter_path : String, cell : Vector2):
	var scene = load(drifter_path)
	assert(scene,"bad drifter path: "+drifter_path)
	var drifter:Drifter = scene.instance()
	assert(drifter.major_element != 0, "major element can't be 0 (guts)")
	assert(drifter.minor_element != 0, "minor element can't be 0 (guts)")
	drifter._my_own_path = drifter_path
	_add_drifter_node(drifter, cell)
func _add_drifter_node(drifter : Drifter, cell : Vector2):
	# !! the order of the next two lines matters !!
	$DRIFTERS.add_child(drifter)
	reregister(drifter,cell)
	
	_initialize_drifter(drifter)
#	yield(drifter, "drifter_entered")

func _initialize_drifter(drifter : Drifter):
	drifter.target_position = $TileMap.map_to_world(drifter.cell)
	drifter.position = drifter.target_position

var _to_kill:Array # [Drifter]
var _to_spawn:Array # [String]
var _to_spawn_where:Array # [Vector2]
var _to_move:Array # [Drifter]
var _to_move_where:Array # [Vector2]
var _clicked:bool
var _clicked_cell:Vector2

func _physics_process(_delta):
	_to_kill.clear()
	_to_spawn.clear()
	_to_spawn_where.clear()
	_to_move.clear()
	_to_move_where.clear()
	
	for drifter in $DRIFTERS.get_children():
		if drifter.evolve_wait_frames <= 0 and randf()*drifter.evolve_skip_odds<1:
			drifter.evolve()
			drifter.evolve_wait_frames = drifter.evolve_wait_after
	if _clicked:
		var drifter = _get_drifter_at_cell(_clicked_cell)
		if drifter:
			drifter.tweak()
		else:
			# add a completely random thingy.
			var path = spawnables[randi() % spawnables.size()].resource_path
			intend_spawn_at(path, _clicked_cell)
		_clicked = false
	
	# process _to_kill
	for drifter in _to_kill:
		_free_after_20_frames(drifter)
	
	# process _to_spawn
	assert(len(_to_spawn)==len(_to_spawn_where),"_to_spawn desync")
	for i in range(len(_to_spawn)):
		_add_drifter(_to_spawn[i],_to_spawn_where[i])
		
	# process _to_move
	assert(len(_to_move)==len(_to_move_where), "_to_move desync")
	for i in range(len(_to_move)):
		var drifter = _to_move[i]
		var cell = _to_move_where[i]
		reregister(drifter,cell)
		drifter.target_position = $TileMap.map_to_world(drifter.cell)

	for key in drifter_dictionary:
		var overlapping_drifters = drifter_dictionary[key]
		if len(overlapping_drifters) > 1:
#			print("Overlapping at ",key)
			for drifter in overlapping_drifters:
#				assert(drifter.get_parent() == $DRIFTERS)
#				assert(not drifter.dead)
				if drifter.dead:
					drifter._todays_guts = -1
				else:
					var percent = drifter.guts/100.0
					drifter._todays_guts = randf()*percent*percent
#					print(" guts: ",drifter.guts," ",percent," today: ",drifter._todays_guts," (",drifter._my_own_path,")")
			var gutsiest_drifter = null
			var gutsiest_guts: float = 0
			for drifter in overlapping_drifters:
				if drifter._todays_guts > gutsiest_guts:
					gutsiest_guts = drifter._todays_guts
					gutsiest_drifter = drifter
#					print("  new best: ",gutsiest_guts," ",gutsiest_drifter._my_own_path)
#				else:
#					print("  not enough: ",drifter._todays_guts," ",drifter._my_own_path)
#			print(" winner: ",gutsiest_drifter._my_own_path)
			for drifter in overlapping_drifters:
				if drifter != gutsiest_drifter:
					_free_after_20_frames(drifter)

# 20 frames ish; the exact number doesn't matter
func _free_after_20_frames(drifter):
	if not drifter.dead:
		drifter.dead = true
		yield(get_tree(),"idle_frame")
		assert(drifter.get_parent() == $DRIFTERS,"bad drifter parent/.dead state")
		$DRIFTERS.remove_child(drifter)
		$DEAD_DRIFTERS.add_child(drifter)
		yield(get_tree().create_timer(0.2),"timeout")
		drifter.queue_free()

func max_vibe_at_dir(cellcenter:Vector2, celldiffs:Array, weights, noise:float) -> Vector2:
	var result = null
	var best_score = 0
	for dcell in celldiffs:
		var score = vibe_at(cellcenter+dcell).weight_by(weights) + noise*randf()
		if not result or score > best_score:
			result = dcell # return value is relative to cellcenter (it's not the absolute position)
			best_score = score
	return result

func max_vibe_nearby_dir(cellcenter:Vector2, celldiffs:Array, weights, noise:float) -> Vector2:
	var result = null
	var best_score = 0
	for dcell in celldiffs:
		var score = vibe_nearby(cellcenter+dcell).weight_by(weights) + noise*randf()
		if not result or score > best_score:
			result = dcell # return value is relative to cellcenter (it's not the absolute position)
			best_score = score
	return result
	
########
# useful things drifters can call:
########

# a weighted sum of the vibes of the 8 nearby tiles
# weights are specifically like this; (a,b), where a scales the major element and b scales the minor element:
#   (1,0) (3,1) (1,0)
#   (3,1) (0,0) (3,1)
#   (1,0) (3,1) (1,0)
# (the (0,0) weight in the center there represents the center cell)
# the total guts nearby is also returned as part of the vibe
func vibe_nearby(cell:Vector2):
	var result = Vibe.new({})
	for dcell in [Vector2.LEFT, Vector2.RIGHT, Vector2.DOWN, Vector2.UP]:
		var drifter = _get_drifter_at_cell(cell+dcell)
		if drifter:
			result.add_element(drifter.major_element,3)
			result.add_element(drifter.minor_element,1)
			result.add_guts(drifter.guts)
	for dcell in [Vector2(1,1), Vector2(-1,-1), Vector2(1,-1), Vector2(-1,1)]:
		var drifter = _get_drifter_at_cell(cell+dcell)
		if drifter:
			result.add_element(drifter.major_element,1)
			result.add_guts(drifter.guts)
	return result

func vibe_at(cell:Vector2):
	var result = Vibe.new({})
	var drifter = _get_drifter_at_cell(cell)
	if drifter:
		result.add_element(drifter.major_element,3)
		result.add_element(drifter.minor_element,1)
		result.add_guts(drifter.guts)
	return result

func intend_kill(drifter:Drifter):
	if drifter:
		_to_kill.append(drifter)
func intend_kill_at(newcell:Vector2):
	intend_kill(_get_drifter_at_cell(newcell))
func intend_spawn_at(path:String, newcell:Vector2):
	_to_spawn.append(path)
	_to_spawn_where.append(newcell)
func intend_move_to(drifter:Drifter, newcell:Vector2):
	if not drifter.immovable:
		_to_move.append(drifter)
		_to_move_where.append(newcell)
func intend_move_from_to(cell1:Vector2, cell2:Vector2):
	var d1 = _get_drifter_at_cell(cell1)
	if d1: intend_move_to(d1,cell2)
func intend_swap(cell1:Vector2, cell2:Vector2):
	var d1 = _get_drifter_at_cell(cell1)
	var d2 = _get_drifter_at_cell(cell2)
	if d1: intend_move_to(d1,cell2)
	if d2: intend_move_to(d2,cell1)

func log(msg:String):
	$LogHandler.add_log(msg)
#	print("log: ",msg)
