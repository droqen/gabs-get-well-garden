extends Node2D
class_name Drifter

var _my_own_path = ""

#signal drifter_entered

onready var world = $"../.." # refers to the GardenWorld

func get_world():
	if world: return world
	else: return $"../.."

var target_position: Vector2

var _todays_guts: float # internal use
var __registered: bool = false # dont touch this omg
var dead: bool = false

var cell:Vector2
export(int, 0, 100)var guts = 40
export(Vibe.Element)var major_element = Vibe.Element.Earth
export(Vibe.Element)var minor_element = Vibe.Element.Water
export(int, 1, 1000000)var evolve_skip_odds = 400 # 1 = run evolve() every frame; higher = run less often (e.g. 1000 = run with probability 1/1000 every frame)
export(int, 0, 3600)var evolve_wait_after = 0

var evolve_wait_frames:int = 0

const DirsOrthogonal = [Vector2.LEFT, Vector2.RIGHT, Vector2.DOWN, Vector2.UP]
const DirsAdjacent = [Vector2.LEFT, Vector2.RIGHT, Vector2.DOWN, Vector2.UP,
	Vector2(1,1), Vector2(-1,-1), Vector2(1,-1), Vector2(-1,1)]

func _enter_tree():
	if not dead: get_world().register(self)
func _exit_tree():
	get_world().unregister(self)

func evolve():
	# default behaviour: NO EFFECT
	pass
	# default behaviour: TWEAK
	# tweak()

func tweak():
	# default behaviour: NO EFFECT
	pass
	# default behaviour: CLONE
	# intend_clone(DirsOrthogonal[randi()%4])
	# default behaviour: DESTROY
#	queue_free()

func _physics_process(_delta):
	lerp_position()
	if evolve_wait_frames > 0: evolve_wait_frames -= 1

func lerp_position():
	position = lerp(position, target_position, 0.1)

########
# useful things drifters can call:
########
	
func intend_die():
	world.intend_kill(self)
func intend_kill(dir:Vector2):
	world.intend_kill_at(cell+dir)
func intend_spawn(path:String, dir:Vector2):
	world.intend_spawn_at(path, cell+dir)
# swap by default
func intend_move(dir:Vector2):
	world.intend_swap(cell, cell+dir)
# move, and use guts to determine who gets to stay in the cell (if there are contenders)
func intend_move_noswap(dir:Vector2):
	world.intend_move_to(self, cell+dir)
func intend_move_and_leave(dir:Vector2, path:String):
	world.intend_spawn_at(path, cell)
	world.intend_move_to(self, cell+dir)
func intend_clone(dir:Vector2):
	world.intend_spawn_at(_my_own_path, cell+dir)
func intend_transmute(path:String):
	world.intend_kill(self)
	world.intend_spawn_at(path, cell)

func vibiest_dir(dirs:Array, weights) -> Vector2:
	return world.max_weighted_relative(cell,dirs,weights,1.0)

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
