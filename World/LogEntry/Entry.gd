extends Node2D
var text = ""
var count = 1
var v_pos
var target = 0

func _ready():
	$Label.text = text
	update_self_worth()
	pass # Replace with function body.


func _process(delta):
	modulate = lerp(Color.transparent, Color.white, sqrt(min($Timer.time_left, 0.25) / 0.25) )
	position.y = lerp(position.y, target, delta*10)
	$Label/Counter.rect_scale = lerp($Label/Counter.rect_scale, Vector2.ONE, delta*15)
	pass


func _on_Timer_timeout():
	get_parent().remove_log(self)
	pass # Replace with function body.

func respawn():
	update_self_worth()
	$Label/Counter.rect_scale = 1.5 * Vector2.ONE
	count += 1
	$Timer.start()
	$Label/Counter.text = "X" + str(count)

func update_self_worth():
	var unimportance = get_parent().get_entry_count(text)
	var time_allowed = 5*pow(0.6, sqrt(unimportance)-1)
	$Timer.wait_time = min(time_allowed, $Timer.wait_time)
	pass
