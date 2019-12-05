 
extends Node

export(String,MULTILINE) var pokedex = ""
export(String,MULTILINE) var pokemon_types = ""
export(String,MULTILINE) var pokemon_moves = ""

var pokemons = []
var types = []
var moves = []
var container
var index = 0
var names
var object = ""
var text
var d
var pkm
func _ready():
	var dummy = Node.new()
	pokemons.push_back(dummy)
	types.push_back(dummy)
	moves.push_back(dummy)
	var pkm_container = get_node("pokemons")
	for pkm in pkm_container.get_children():
#		if pkm.id == 1:
#		print(pkm.Name)
#		print(pkm.learn_move_id.size())
#			print(str(pkm.abilities[0]) + ", " + str(pkm.abilities[1]) + ", " + str(pkm.abilities[2]))
		pokemons.push_back(pkm)
	var type_container = get_node("pokemon_types")
	for type in type_container.get_children():
		types.push_back(type)
	var move_container = get_node("pokemon_moves")
	for move in move_container.get_children():
		moves.push_back(move)

func add_item(item_id, cant = 1):
	var item = get_item(item_id)
	print("ADDING ITEM: " + str(item.Name))
	for i in GAME_DATA.ITEMS:
		if i.size() > 0 and i[0].id == item.id:
			for x in range(cant):
				x=x
				i.append(item)
			return
	var new_slot = []
	for x in range(cant):
		x=x
		new_slot.push_back(item)
	GAME_DATA.ITEMS.push_back(new_slot)
	
			
func get_item(item):
	if typeof(item) == TYPE_INT:
		return $items.get_children()[item-1]
	elif typeof(item) == TYPE_STRING:
		for i in $items.get_children():
			if item in i.get_name().split("-")[1]:
				return i
	return null
	
func print_items():
	
	for i in GAME_DATA.ITEMS:
		if i.size() > 0:
			print(str(i.size()) + " " + i[0].Name)
