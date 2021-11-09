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
export(int, 1, 1000000)var evolve_skip_odds = 20 # 1 = run evolve() every frame; higher = run less often (e.g. 1000 = run with probability 1/1000 every frame)
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
	self.tweak()

func tweak():
	# default behaviour: NO EFFECT
	pass
	# default behaviour: CLONE
	# intend_spawn(_my_own_path,DirsOrthogonal[randi()%4])
	# default behaviour: DESTROY
#	queue_free()

func _physics_process(_delta):
	lerp_position()
	if evolve_wait_frames > 0: evolve_wait_frames -= 1

func lerp_position():
	position = lerp(position, target_position, 0.1)

func intend_kill():
	world.intend_kill(self)
func intend_spawn(path:String, dir:Vector2):
	world.intend_spawn_at(path, cell+dir)
func intend_move(dir:Vector2):
	world.intend_move_to(self, cell+dir)
# convenient variations:
func intend_transmute(path:String):
	world.intend_kill(self)
	world.intend_spawn_at(path, cell)
func intend_spawn_at(path:String, newcell:Vector2):
	world.intend_spawn_at(path, newcell)
func intend_move_to(newcell:Vector2):
	world.intend_move_to(self, newcell)
