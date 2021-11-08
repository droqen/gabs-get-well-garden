tool
extends Sprite
class_name NavdiBitsySprite
export(Array, int
) var _frames = [0,1]
export(int) var _frame_period: float = 10
var ani = 0

var frames: Array setget set_frames, get_frames
var frame_period: float setget set_frame_period, get_frame_period

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if texture:
		if _frame_period <= 0:
			set_process(false)
		else:
			ani = fmod(ani + 1/_frame_period, len(_frames))
			frame = _frames[int(ani)]

func setup(__frames: Array, __frame_period: float):
	set_frames(__frames)
	set_frame_period(__frame_period)
	return self

func set_frames(__frames: Array):
	_frames = __frames
	ani = fmod(ani, len(_frames))
	frame = _frames[int(ani)]

func get_frames() -> Array:
	return _frames

func set_frame_period(__frame_period: float):
	_frame_period = __frame_period
	set_process(_frame_period <= 0)

func get_frame_period() -> float:
	return _frame_period

func next_frame(frame_advance = 1):
	ani = fmod(ani + frame_advance, len(_frames))
	frame = _frames[int(ani)]
