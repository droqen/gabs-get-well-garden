extends Drifter

var anim = 0.0

func _process(_delta):
	anim += _delta
	$Sprite.scale = Vector2(1, 1+(sin((anim)*2*PI)/10))
	$Sprite.rotation_degrees = (sin(anim*1*PI))*10
func evolve():
	if randf()<.1:
		tweak()
func tweak():
	intend_transmute("res://DriftersUserDefined/waporwave/Tombstone.tscn")
