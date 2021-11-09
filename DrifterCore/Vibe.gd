class_name Vibe

enum Aspect {
	Guts=0, # special
	Normal=1,
	Fire=2,
	Water=3,
	Grass=4,
	Electric=5,
	Ice=6,
	Fighting=7,
	Poison=8,
	Ground=9,
	Flying=10,
	Psychic=11,
	Bug=12,
	Rock=13,
	Ghost=14,
	Dark=15,
	Dragon=16,
	Steel=17,
	Fairy=18,
}

var elements:Array = [0,
0,0,0,0,0, 0,0,0,0,0,
0,0,0,0,0, 0,0,0, ] # index '0' + '18' elemental type indices

func _add_element(typeid:int, value:int):
	elements[typeid] += value

func get_element(typeid:int) -> int:
	return elements[typeid]
