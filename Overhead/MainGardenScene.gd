extends Node2D

var last_mouse_viewport_position:Vector2 # used to pan camera
var camera_speed:Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var mouse_position = get_viewport().get_mouse_position()
	var mouse_position_after_camera = mouse_position
	mouse_position_after_camera -= get_viewport().size * 0.5
	mouse_position_after_camera.x *= $Camera2D.zoom.x
	mouse_position_after_camera.y *= $Camera2D.zoom.y
	mouse_position_after_camera += $Camera2D.position
	$GardenWorld/cell_cursor.set_mouse_position(mouse_position_after_camera)

	if Input.is_mouse_button_pressed(BUTTON_MIDDLE):
		var mouse_delta = last_mouse_viewport_position - mouse_position
		mouse_delta.x *= $Camera2D.zoom.x
		mouse_delta.y *= $Camera2D.zoom.y
		$Camera2D.position += mouse_delta
	last_mouse_viewport_position = mouse_position

	if Input.is_action_pressed("ui_right"):
		camera_speed += 0.3*Vector2.RIGHT
	if Input.is_action_pressed("ui_left"):
		camera_speed += 0.3*Vector2.LEFT
	if Input.is_action_pressed("ui_up"):
		camera_speed += 0.3*Vector2.UP
	if Input.is_action_pressed("ui_down"):
		camera_speed += 0.3*Vector2.DOWN
	camera_speed *= 0.9
	$Camera2D.position += camera_speed
