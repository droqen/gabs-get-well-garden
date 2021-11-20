extends Node2D
class_name Drifter

#signal drifter_entered

export(int, 0, 100)var guts = 40
export(Vibe.Element)var major_element = Vibe.Element.Earth
export(Vibe.Element)var minor_element = Vibe.Element.Water
export(int, 1, 1000000)var evolve_skip_odds = 400 # 1 = run evolve() every frame; higher = run less often (e.g. 1000 = run with probability 1/1000 every frame)
export(int, 0, 3600)var evolve_wait_after = 0
export(bool)var immovable = false

# internal use:
var _my_own_path = ""
var _todays_guts: float
var __registered: bool = false # dont touch this omg

func get_world():
	if world: return world
	else: return $"../.."
func _enter_tree():
	if not dead: get_world().register(self)
func _exit_tree():
	get_world().unregister(self)
func _set_cell_error(_newcell:Vector2):
	assert(false, "don't set cell directly; call intend_move(dir) or intend_move_to(newcell) instead")
func _rawset_cell(newcell:Vector2):
	cell = newcell
	
########
# things to override
########

func evolve():
	# default behaviour: NO EFFECT
	pass
	# default behaviour: TWEAK
	# tweak()

func tweak():
	# default behaviour: NO EFFECT
	pass
	# default behaviour: CLONE
#	intend_clone(DirsOrthogonal[randi()%4])
	# default behaviour: DESTROY
#	queue_free()

var target_position:Vector2
var target_scale:Vector2 = Vector2(1,1)
var target_rotation_degrees:float
var evolve_wait_frames:int = 0
func _ready():
	scale = Vector2.ZERO
func _physics_process(_delta):
	position = lerp(position, target_position, 0.05)
	if dead: scale = lerp(scale, Vector2.ZERO, 0.05)
	else:    scale = lerp(scale, target_scale, 0.05)
	rotation_degrees = lerp(rotation_degrees, target_rotation_degrees, 0.05)

	if evolve_wait_frames > 0: evolve_wait_frames -= 1

########
# useful things for drifters to use:
########

onready var world = $"../.." # refers to the GardenWorld

const DirsOrthogonal = [Vector2.LEFT, Vector2.RIGHT, Vector2.DOWN, Vector2.UP]
const DirsAdjacent = [Vector2.LEFT, Vector2.RIGHT, Vector2.DOWN, Vector2.UP,
	Vector2(1,1), Vector2(-1,-1), Vector2(1,-1), Vector2(-1,1)]
var dead: bool = false # this is true for drifters that have died, but are still onscreen (e.g. fading away)
var cell:Vector2 setget _set_cell_error

func intend_die():
	world.intend_kill(self)
func intend_kill(dir:Vector2):
	world.intend_kill_at(cell+dir)
func intend_spawn(path:String, dir:Vector2):
	world.intend_spawn_at(path, cell+dir)
# swap by default
func intend_move(dir:Vector2):
	world.intend_swap(cell, cell+dir)
# move (without swapping) and leave something behind
func intend_move_and_leave(dir:Vector2, path:String):
	world.intend_spawn_at(path, cell)
	world.intend_move_to(self, cell+dir)
func intend_clone(dir:Vector2):
	world.intend_spawn_at(_my_own_path, cell+dir)
func intend_transmute(path:String):
	world.intend_kill(self)
	world.intend_spawn_at(path, cell)

func vibiest_dir(dirs:Array, weights) -> Vector2:
	return max_vibe_at_dir(dirs,weights)

func max_vibe_at_dir(dirs:Array, weights) -> Vector2:
	return world.max_vibe_at_dir(cell,dirs,weights,1.0)
func max_vibe_nearby_dir(dirs:Array, weights) -> Vector2:
	return world.max_vibe_nearby_dir(cell,dirs,weights,1.0)

# call this during _ready
func validated_drifter_path(respath:String) -> String:
	var scene = load(respath)
	assert(scene,"bad drifter path: "+respath)
	return respath

#
# not recomended, but they're available if you like:
# let's keep interactions mostly local!
#

func intend_spawn_at(path:String, newcell:Vector2):
	world.intend_spawn_at(path, newcell)
func intend_move_to(newcell:Vector2):
	world.intend_swap(cell, newcell)
func intend_clone_at(newcell:Vector2):
	world.intend_spawn_at(_my_own_path, newcell)
# move, and use guts to determine who gets to stay in the cell (if there are contenders)
func intend_move_noswap(dir:Vector2):
	world.intend_move_to(self, cell+dir)
