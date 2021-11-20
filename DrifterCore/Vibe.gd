class_name Vibe

enum Element {
	Guts = 0,   # "Guts" is special! don't use it as your major_element/minor_element
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

# e.g.
#   var weights:Vibe = Vibe.new({"Fire":1,"Water":-2})
# capitalization matters!
func _init(dict:Dictionary):
	for strkey in dict:
		var id = Element.get(strkey)
		assert(id != null,"bad vibe key \""+strkey+"\"")
		elements[id] += dict[strkey]
	
func add_guts(value:int):
	elements[0] += value
func add_element(typeid:int, value:int):
	elements[typeid] += value

func scale(value:int) -> Vibe:
	var result = get_script().new({})
	for id in range(len(elements)):
		result.elements[id] = elements[id]*value
	return result

func sum(other:Vibe) -> Vibe:
	var result = get_script().new({})
	for id in range(len(elements)):
		result.elements[id] = elements[id] + other.elements[id]
	return result

func to_string():
	var result = "vibe{"
	var names = Element.keys()
	for id in range(len(elements)):
		result += names[id] + ":" + str(elements[id]) + ", "
	result += "}"
	return result

#############
# useful for drifter authors:
#############

func get_guts() -> int:
	return elements[Element.Guts]
func get_fire() -> int:
  return elements[Element.Fire]
func get_water() -> int:
  return elements[Element.Water]
func get_earth() -> int:
  return elements[Element.Earth]
func get_grass() -> int:
  return elements[Element.Grass]
func get_wind() -> int:
  return elements[Element.Wind]
func get_sand() -> int:
  return elements[Element.Sand]
func get_gem() -> int:
  return elements[Element.Gem]
func get_coal() -> int:
  return elements[Element.Coal]

func get_element(typeid) -> int:
	if typeid is String:
		typeid = Element.get(typeid)
	return elements[typeid]

func weight_by(weights) -> float:
	if weights is Dictionary:
		weights = get_script().new(weights)
	
	var result = 0.0
	for id in range(len(elements)):
		result += elements[id] * weights.elements[id]
	return result
		
