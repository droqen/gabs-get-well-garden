extends Node2D

const spawnables = [
	"res://DriftersUserDefined/droqen-debug/BigSnail.tscn",
	"res://DriftersUserDefined/pancelor-debug/Sapling.tscn",
	"res://DriftersUserDefined/pancelor-debug/Flames.tscn",
]

var drifter_dictionary:Dictionary = {}

func cellkey(cell:Vector2):
	return cell.x+10000*cell.y
func register(d:Drifter):
	if d.__registered: return
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
	d.cell = newcell
	if d.get_parent() == $DRIFTERS: register(d)
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
	_clicked = true
	_clicked_cell = cell
	print(vibe_nearby(cell).to_string())

func reinitialize_drifters(drifters : Array):
	for drifter in drifters:
		_initialize_drifter(drifter)

func add_drifter(drifter_path : String, cell : Vector2):
	var drifter = load(drifter_path).instance()
	drifter._my_own_path = drifter_path
	_add_drifter_node(drifter, cell)
func _add_drifter_node(drifter : Drifter, cell : Vector2):
	# order of the next two lines matters:
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
			drifter.evolve_wait_frames = drifter.evolve_wait_after
			drifter.evolve()
	if _clicked:
		var drifter = _get_drifter_at_cell(_clicked_cell)
		if drifter:
			drifter.tweak()
		else:
			# add a completely random thingy.
			var path = spawnables[randi() % spawnables.size()]
			intend_spawn_at(path, _clicked_cell)
		_clicked = false
		
	for drifter in _to_kill:
		_free_after_20_frames(drifter)
	
	assert(len(_to_spawn)==len(_to_spawn_where),"_to_spawn desync")
	for i in range(len(_to_spawn)):
		add_drifter(_to_spawn[i],_to_spawn_where[i])
		
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
				var percent = drifter.guts/100.0
				drifter._todays_guts = randf()*percent*percent
#				print(" guts: ",drifter.guts," ",percent," today: ",drifter._todays_guts," (",drifter._my_own_path,")")
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
	var result = Vibe.new()
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
	return result

func vibe_at(cell:Vector2):
	var result = Vibe.new()
	var drifter = _get_drifter_at_cell(cell)
	if drifter:
		result.add_element(drifter.major_element,3)
		result.add_element(drifter.minor_element,1)
		result.add_guts(drifter.guts)
	return result

func cell_with_most(element, cells:Array):
	var result = null
	var amount_result = 0
	for c in cells:
		var amt = vibe_at(c).get_element(element)
		if amt > amount_result:
			result = c
			amount_result = amt
	return result
	
func intend_kill(drifter:Drifter):
	_to_kill.append(drifter)
func intend_spawn_at(path:String, cell:Vector2):
	_to_spawn.append(path)
	_to_spawn_where.append(cell)
func intend_move_to(drifter:Drifter, cell:Vector2):
	_to_move.append(drifter)
	_to_move_where.append(cell)
	
func log(msg:String):
	print("log: ",msg)
	pass
