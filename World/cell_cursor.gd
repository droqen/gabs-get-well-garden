extends Node2D

signal clicked_cell(cell)

var breath: float

var target_position: Vector2

var clicked: bool = false

var cell: Vector2

onready var tilemap = $"../TileMap"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$fff2.rotation += delta # spin! spin! spin!
	$fff.rotation = 0.1 * sin(breath)
	var target_scale = Vector2.ONE * (1.3 + .1 * sin(breath))
	$fff.position = lerp($fff.position, target_position, 0.5)
	
	modulate.a = lerp(modulate.a, 1, 0.05)
	$fff.scale = lerp($fff.scale, target_scale, 0.2)
	
	if Input.is_mouse_button_pressed(1):
		if not clicked:
			clicked = true
			$fff.scale = Vector2(2,2)
			modulate.a = 2
			target_scale *= 1.5
			emit_signal("clicked_cell", cell)
	else:
		clicked = false
		
	breath += lerp(-9.22, 4.22, 2-modulate.a) * delta
		

func set_mouse_position(mouse_position):
	mouse_position -= Vector2(1,1)
	$fff2.position = mouse_position
	cell = tilemap.world_to_map(lerp(mouse_position+Vector2(5,5),tilemap.map_to_world(cell),0.15))
	target_position = tilemap.map_to_world(cell)
