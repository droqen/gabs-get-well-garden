extends Node2D
export (PackedScene) var LogEntry
export var v_offset = 12
var log_repetition_db = [[],[]]

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func add_log(message : String):
	count_log_entry_in_db(message)
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
		max_count = get_entry_count(get_child(0).text)
		
		
	for i in range(1, get_child_count()):
		if get_entry_count(get_child(i).text) > max_count:
			max_count = get_entry_count(get_child(i).text)
			move_child(get_child(i), i-1)
	
	for i in range(get_child_count()):
		get_child(i).target = i * v_offset
	pass

func count_log_entry_in_db(log_text):
	var search_result = log_repetition_db[0].find(log_text)
	if search_result == -1:
		log_repetition_db[0].append(log_text)
		log_repetition_db[1].append(1)
	else:
		log_repetition_db[1][search_result] += 1

func get_entry_count(log_text) -> int:
	var search_result = log_repetition_db[0].find(log_text)
	if search_result == -1:
		return 0
	else:
		return log_repetition_db[1][search_result]

func _on_UpdateRarity_timeout():
	for entry_index in log_repetition_db[1].size():
		log_repetition_db[1][entry_index] = ceil(0.5 * log_repetition_db[1][entry_index])
	
#	print(log_repetition_db)
