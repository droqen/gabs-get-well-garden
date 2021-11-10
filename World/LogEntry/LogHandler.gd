extends Node2D
export (PackedScene) var LogEntry
export var v_offset = 12

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func add_log(message : String):
	for child in get_children():
		if not child.get("text") == null:
			if child.text.find(message) != -1:
				child.respawn()
#				move_child(child, 0)
				call_deferred("update_log_positions")
				return
			pass
		pass
	spawn_entry(message)
	call_deferred("update_log_positions")
	
	pass

func spawn_entry(message: String):
	var new_entry = LogEntry.instance()
	new_entry.text = message
	add_child(new_entry)
#	move_child(new_entry, 0)
	pass

func remove_log(node_to_remove):
	node_to_remove.queue_free()
	call_deferred("update_log_positions")
	pass

func update_log_positions():
	var max_count = 0
	if get_child_count() > 0:
		max_count = get_child(0).count
		
		
	for i in range(1, get_child_count()):
		if get_child(i).count > max_count:
			max_count = get_child(i).count
			move_child(get_child(i), i-1)
	
	for i in range(get_child_count()):
		get_child(i).target = i * v_offset
	pass
