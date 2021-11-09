extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_position = get_viewport().get_mouse_position()
	var mouse_position_after_camera = mouse_position
	mouse_position_after_camera -= get_viewport().size * 0.5
	mouse_position_after_camera.x *= $Camera2D.zoom.x
	mouse_position_after_camera.y *= $Camera2D.zoom.y
	mouse_position_after_camera += $Camera2D.position
	$fff.position = mouse_position_after_camera
	$GardenWorld/cell_cursor.set_mouse_position(mouse_position_after_camera)
