extends Node2D
class_name Drifter

signal drifter_entered

var target_position: Vector2

func has_intent() -> bool:
	return (
		intent_move != Vector2.ZERO
		or
		intent_spawn_drifter
	)

func clear_intent():
	intent_move = Vector2.ZERO
	intent_spawn_drifter = null
	intent_spawn_dir = Vector2.ZERO

var intent_move: Vector2
var intent_spawn_drifter: Drifter
var intent_spawn_dir: Vector2

var cell:Vector2
export(int, 0, 10)var guts = 5 # should be enough variety?
export(Elemental.Type)var type1 = Elemental.Type.Normal
export(Elemental.Type)var type2 = Elemental.Type.Normal
export(int, 0, 100)var evolve_percentage_chance = 5
export(int, 0, 1000)var evolve_wait_after = 0

var evolve_wait_frames:int = 0

const DirsOrthogonal = [Vector2.LEFT, Vector2.RIGHT, Vector2.DOWN, Vector2.UP]
const DirsAdjacent = [Vector2.LEFT, Vector2.RIGHT, Vector2.DOWN, Vector2.UP,
	Vector2(1,1), Vector2(-1,-1), Vector2(1,-1), Vector2(-1,1)]

func _enter_tree():
	emit_signal("drifter_entered", self)

func set_cell(_cell):
	self.cell = _cell

func evolve(vibe:Vibe):
	self.tweak(vibe)

func tweak(vibe:Vibe):
	pass

func _physics_process(_delta):
	lerp_position()
	if evolve_wait_frames > 0: evolve_wait_frames -= 1

func lerp_position():
	position = lerp(position, target_position, 0.1)
