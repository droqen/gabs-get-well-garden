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

func has_intent() -> bool:
	return (
		intent_move != Vector2.ZERO
		or
		intent_spawn_drifter
	)

func clear_intent():
	intent_move = Vector2.ZERO
	intent_spawn_drifter = ""
	intent_spawn_dir = Vector2.ZERO

var intent_move: Vector2
var intent_spawn_drifter: String
var intent_spawn_dir: Vector2

var cell:Vector2
export(int, 0, 100)var guts = 40
export(Elemental.Type)var type1 = Elemental.Type.Normal
export(Elemental.Type)var type2 = Elemental.Type.Normal
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

func set_cell(_cell):
	if is_inside_tree(): get_world().unregister(self)
	self.cell = _cell
	if is_inside_tree() and not dead: get_world().register(self)

func evolve(vibe:Vibe):
	self.tweak(vibe)

func tweak(vibe:Vibe):
	# default behaviour: NO EFFECT
	pass
	# default behaviour: CLONE
#	intent_spawn_drifter = _my_own_path
#	intent_spawn_dir = DirsOrthogonal[randi()%4]
	# default behaviour: DESTROY
#	queue_free()

func _physics_process(_delta):
	lerp_position()
	if evolve_wait_frames > 0: evolve_wait_frames -= 1

func lerp_position():
	position = lerp(position, target_position, 0.1)
