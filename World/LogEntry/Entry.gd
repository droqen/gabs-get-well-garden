extends Node2D
var text = ""
var count = 1
var v_pos
var target = 0

func _ready():
	$Label.text = text
	pass # Replace with function body.


func _process(delta):
	modulate = lerp(Color.transparent, Color.white, $Timer.time_left / $Timer.wait_time )
	position.y = lerp(position.y, target, delta*10)
	$Label/Counter.rect_scale = lerp($Label/Counter.rect_scale, Vector2.ONE, delta*15)
	pass


func _on_Timer_timeout():
	get_parent().remove_log(self)
	pass # Replace with function body.

func respawn():
	$Label/Counter.rect_scale = 1.5 * Vector2.ONE
	count += 1
	$Timer.start()
	$Label/Counter.text = "X" + str(count)
