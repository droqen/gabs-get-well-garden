extends Node2D

signal clicked_cell(cell,button)
signal dragged_cell(cell,button)

var breath: float
var target_position: Vector2
var cell: Vector2

onready var tilemap = $"../TileMap"

var _btn_was_down:Array = [false,false,false,false]
func mbtnp(button : int) -> bool:
	assert(button == BUTTON_LEFT or button == BUTTON_RIGHT or button == BUTTON_MIDDLE)
	if Input.is_mouse_button_pressed(button):
		if not _btn_was_down[button]:
			_btn_was_down[button] = true
			return true
	else:
		_btn_was_down[button] = false
	return false

# a bit hacky: BUTTON_RIGHT is hard-coded
var _lastcell
func mbtn_cell() -> bool:
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		if cell!=_lastcell:
			_lastcell = cell
			return true
	else:
		_lastcell=null
	return false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$fff2.rotation += delta # spin! spin! spin!
	$fff.rotation = 0.1 * sin(breath)
	var target_scale = Vector2.ONE * (1.3 + .1 * sin(breath))
	$fff.position = lerp($fff.position, target_position, 0.5)
	
	modulate.a = lerp(modulate.a, 1, 0.05)
	$fff.scale = lerp($fff.scale, target_scale, 0.2)
	
	if mbtnp(BUTTON_LEFT):
		$fff.scale = Vector2(2,2)
		modulate.a = 2
		target_scale *= 1.5
		emit_signal("clicked_cell", cell, BUTTON_LEFT)
	elif mbtnp(BUTTON_MIDDLE):
		emit_signal("clicked_cell", cell, BUTTON_MIDDLE)
#	elif mbtnp(BUTTON_RIGHT):
#		emit_signal("clicked_cell", cell, BUTTON_RIGHT)

	if mbtn_cell():
		emit_signal("dragged_cell", cell, BUTTON_RIGHT)
	breath += lerp(-9.22, 4.22, 2-modulate.a) * delta
		

func set_mouse_position(mouse_position):
	mouse_position -= Vector2(1,1)
	$fff2.position = mouse_position
	cell = tilemap.world_to_map(lerp(mouse_position+Vector2(5,5),tilemap.map_to_world(cell),0.15))
	target_position = tilemap.map_to_world(cell)
