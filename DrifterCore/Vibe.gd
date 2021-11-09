class_name Vibe

enum Element {
				# alternate interpretations: (feel free to make up your own interpretations too!)
	Fire = 1,   #  red, energy, passion
	Water = 2,  #  blue, wisdom, adaptability
	Earth = 3,  #  brown, stability, calm
	Grass = 4,  #  green, life, progress
	Wind = 5,   #  white, change, restlessness
	Sand = 6,   #  yellow, volatility, intelligence
	Gem = 7,    #  purple, magic, uniqueness
	Coal = 8,   #  black, death, decay
}

var elements:Array = [0,
0,0,0,0, 0,0,0,0, ] # index '0' (guts) + '8' element slots

func add_guts(value:int):
	elements[0] += value

func add_element(typeid:int, value:int):
	elements[typeid] += value

func get_element(typeid:int) -> int:
	return elements[typeid]

func scale(value:int) -> Vibe:
	var result = get_script().new()
	for key in Element:
		result.elements[key] = elements[key]*value
	return result

func sum(other:Vibe) -> Vibe:
	var result = get_script().new()
	for key in Element:
		result.elements[key] = elements[key] + other.elements[key]
	return result

func weight_by(weights:Vibe) -> Vibe:
	var result = get_script().new()
	for key in Element:
		result.elements[key] = elements[key] * weights.elements[key]
	return result

# e.g.:
#   var local_vibe = world.vibe_nearby(cell)
#   var weights = Vibe.new().add_dictionary({Vibe.Fire: 1, Vibe.Water: -2})
#   var score = local_vibe.weight_by(weights)
func add_dictionary(dict:Dictionary) -> Vibe:
	var result = get_script().new()
	for key in dict:
		result.elements[key] += dict[key]
	return result
	
