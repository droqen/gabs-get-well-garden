extends Node2D
var message = ""

func _ready():
	$Label.text = message

func _process(delta):
	modulate = lerp(Color.transparent, Color.white, sqrt(min($Timer.time_left, 0.25) / 0.25) )
	position.y = lerp(position.y, -10, delta*10)
	pass


func _on_Timer_timeout():
	queue_free()
