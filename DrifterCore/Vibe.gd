class_name Vibe

var elements:Array = [0,
0,0,0,0,0, 0,0,0,0,0,
0,0,0,0,0, 0,0,0, ] # index '0' + '18' elemental type indices

func add_element(typeid:int, value:int):
	elements[typeid] += value

func get_element(typeid:int) -> int:
	return elements[typeid]
