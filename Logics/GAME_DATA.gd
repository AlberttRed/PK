
extends Node

const Pokemon = preload('res://Logics/DB/pokemon.gd')
const Trainer = preload('res://Logics/event/Trainer.gd')

var player_name = "RED"
var trainer: Trainer
var medals = []
var player_id = randi() % 999999 + 1
var actual_position

var ACTUAL_MAP
var PREVIOUS_MAP
var PLAYER

var party = []
var box1 = []
var box2 = []
var box3 = []
var box4 = []
var box5 = []
var box6 = []
var box7 = []
var box8 = []
var box9 = []
var box10 = []
var box11 = []
var box12 = []
var box13 = []
var box14 = []
var box15 = []
var box16 = []
var box17 = []
var box18 = []
var box19 = []
var box20 = []

var battle_front_sprite = preload("res://Sprites/Characters/trainer000.png")
var battle_back_sprite = preload("res://Sprites/Characters/trback000.png")

var player_surf_sprite = preload("res://Sprites/Characters/boy_dive_offset.png")
var player_run_sprite = preload("res://Sprites/Characters/boy_run.png")
var player_default_sprite = preload("res://Sprites/trchar000.png")

func _ready():
#	party.push_back(DB.pokemons[7].make_wild(7))
#	party.push_back(DB.pokemons[4].make_wild(16))

	medals.push_back(CONST.MEDALS.ROCA)
	medals.push_back(CONST.MEDALS.CASCADA)
	medals.push_back(CONST.MEDALS.TRUENO)
	medals.push_back(CONST.MEDALS.ARCOIRIS)
	medals.push_back(CONST.MEDALS.ALMA)
	medals.push_back(CONST.MEDALS.PANTANO)
	medals.push_back(CONST.MEDALS.VOLCAN)
	medals.push_back(CONST.MEDALS.TIERRA)
	for p in party:
		p.dni = player_id
		p.original_trainer = player_name
	
# Note: This can be called from anywhere inside the tree. This function is
# path independent.
# Go through everything in the persist category and ask them to return a
# dict of relevant variables
func save_game():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	
	var game_data = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"player_id" : player_id, # Vector2 is not supported by JSON
		"player_name" : player_name,
		'Player' : PLAYER.call("save"),
		#'ACTUAL_MAP' : ACTUAL_MAP.call("save")
	}
	save_game.store_line(to_json(game_data))
	
#	var save_nodes = get_tree().get_nodes_in_group("Persist")
#	for i in save_nodes:
#		var node_data = i.call("save");
#		save_game.store_line(to_json(node_data))
	save_game.close()
	
# Note: This can be called from anywhere inside the tree. This function
# is path independent.
func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		print("LOADING ERROR: No existex el fitxer.")
		return # Error! We don't have a save to load.
	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
#	var save_nodes = get_tree().get_nodes_in_group("Persist")
#	for i in save_nodes:
#		i.queue_free()
		
	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open("user://savegame.save", File.READ)
	while not save_game.eof_reached():
		var current_line = parse_json(save_game.get_line())
		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(current_line["filename"]).instance()
		get_node(current_line["parent"]).add_child(new_object)
		new_object.position = Vector2(current_line["pos_x"], current_line["pos_y"])
		# Now we set the remaining variables.
		for i in current_line.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i, current_line[i])
	save_game.close()