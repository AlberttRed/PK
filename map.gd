extends Node2D
var Trainer = preload("res://Logics/event/Trainer_class.gd")

export(PackedScene) var N_connection
export(String, FILE, "*.tscn") var S_connection
export(String, FILE, "*.tscn") var E_connection
export(String, FILE, "*.tscn") var W_connection

export(Vector2) var N_connection_pos
export(Vector2) var S_connection_pos
export(Vector2) var E_connection_pos
export(Vector2) var W_connection_pos

var N_scene = null
var S_scene = null
var E_scene = null
var W_scene = null

export(AudioStream) var music

var tile_offset = Vector2(0, 0)
var N

var comptador = 0
onready var wild_pokemon = get_node("Wild_Pokemon_")
export(int) var land_density = 30

var area
var loaded = false
var connections_loaded = false
var strength_on = false


func init():

	comptador += 1
	GAME_DATA.WORLD.get_node("CanvasModulate/CapaTerra_").z_index = -2
	if GAME_DATA.ACTUAL_MAP != null:#ProjectSettings.set("Previous_Map", ProjectSettings.get("Actual_Map"))
		GAME_DATA.PREVIOUS_MAP = GAME_DATA.ACTUAL_MAP
	GAME_DATA.ACTUAL_MAP = self


func _init():
	add_user_signal("loaded")
	add_user_signal("connected")
	
func set_connections():
	var Scene
	if N_connection != null and N_connection_pos != null:
		Scene = N_connection
		var scene_name = N_connection.get_path().split("/")[4].split(".")[0]
		#print(scene_name + " " + str(get_tree().get_nodes_in_group(scene_name).size()))
		if get_tree().get_nodes_in_group(scene_name).size() <= 0:		
			N_scene = Scene.instance()
			GAME_DATA.WORLD.load_map(N_scene, false, get_position() + N_connection_pos)
			connections_loaded = true
	if !S_connection.empty() and S_connection_pos != null:
		print("SSSSSSSSSSSSSSSSSSSSS")
		Scene = load(S_connection).instance()
		if get_tree().get_nodes_in_group(Scene.get_name()).size() <= 0:		
			print("S connected: " + str(Scene.get_name()))
			S_scene = Scene.instance()
			load_map(false, S_scene, S_connection_pos)
	if !E_connection.empty() and E_connection_pos != null:
		print("EEEEEEEEEEEEEEEEEEEEEE")
		Scene = load(E_connection).instance()
		if get_tree().get_nodes_in_group(Scene.get_name()).size() <= 0:		
			print("E connected: " + str(Scene.get_name()))
			E_scene = Scene.instance()
			load_map(false, E_scene, E_connection_pos)
	if !W_connection.empty() and W_connection_pos != null:
		print("WWWWWWWWWWWWWWWWWWWWWWWW")
		Scene = load(W_connection).instance()
		if get_tree().get_nodes_in_group(Scene.get_name()).size() <= 0:		
			print("W connected: " + str(Scene.get_name()))
			W_scene = Scene.instance()
			load_map(false, W_scene, W_connection_pos)

		
func load_map(deletePrevious, scene = self, pos = null):
	init()
	var scene_name = scene.get_name()
	strength_on = false
	if pos != null:
		#print("POSITION " + scene.get_name())
		scene.tile_offset = -scene.get_position() - pos
		scene.set_position(scene.get_position() + pos)

	get_tree().call_group(scene_name, "reparent", scene.position)

	if scene.get_name() != "Ciudad_Verde":
		if GAME_DATA.PLAYER.get_parent() != null:
			GAME_DATA.PLAYER.get_parent().remove_child(GAME_DATA.PLAYER)
		GAME_DATA.WORLD.EVENTOS.add_child(GAME_DATA.PLAYER)
	loaded = true
	if deletePrevious:
		#print("DELETED " + GAME_DATA.PREVIOUS_MAP.get_name())
		if GAME_DATA.PREVIOUS_MAP.N_scene != null:
			GLOBAL.destroy(GAME_DATA.PREVIOUS_MAP.N_scene)
		GLOBAL.destroy(GAME_DATA.PREVIOUS_MAP)
		#GLOBAL.destroy(ProjectSettings.get("Previous_Map"))
	emit_signal("loaded")
		
func get_area(tree):
	for n in tree.get_nodes_in_group(get_name()):
		if n.get_name() == "MapArea_":
			return n
	return null

func save():
	var game_data = {
		"filename" : get_filename(),
		"strength_on" : strength_on # Vector2 is not supported by JSON
	}
	return game_data

func calculate_encounter(double, encounter_method = -1):
	if !ProjectSettings.get("Global_World").disable_battles:
		var method
		if encounter_method != -1:
			method = encounter_method
		else:
			method = select_method()
		if method != null:
			var pkmns = get_node("Wild_Pokemon_").get_child(method)
			#if Player.direction.collides_with(self):
			var rate = rand_range(0,100)
			if (rate <= land_density) and pkmns.get_child_count() > 0:
				var p = int(floor(rand_range(0, pkmns.get_child_count())))
				var chosen_pokemon = pkmns.get_child(p)
				if chosen_pokemon != null and chosen_pokemon.pkmn_id > 0 and chosen_pokemon.pkmn_id <=751:
					GAME_DATA.PLAYER.can_move = false
					print("found! " + DB.pokemons[chosen_pokemon.pkmn_id].name)
					GUI.play_transition("transition_wild_battle")
					yield(GUI, "finished")
					var wild_pkmns = []
					wild_pkmns.push_back(DB.pokemons[chosen_pokemon.pkmn_id].make_wild(floor(rand_range(chosen_pokemon.min_lvl,chosen_pokemon.max_lvl+1))))
					if double:
						wild_pkmns.push_back(DB.pokemons[chosen_pokemon.pkmn_id].make_wild(floor(rand_range(chosen_pokemon.min_lvl,chosen_pokemon.max_lvl+1))))
					
					GUI.init_battle(double, GAME_DATA.trainer, Trainer.new("wild", null, null, null, null, null, false, double, false, false, wild_pkmns, false))
	# aquest es el bo			
				#GUI.init_battle(GAME_DATA.party[0], DB.pokemons[pkmn[p]].make_wild(floor(rand_range(chosen_pokemon.min_lvl,chosen_pokemon.max_lvl+1))))
				#GUI.wild_encounter(pkmn[p], floor(rand_range(min_lvl,max_lvl+1)))

func select_method():
	if GAME_DATA.PLAYER.surfing:
		return CONST.ENCOUNTER_METHODS.WATER
	elif isCave():
		return CONST.ENCOUNTER_METHODS.CAVE
	elif isGrass():
		var time_of_day = 0 #Quan hagi desenvolupat el temps aqui s'haurà d'obtenir si estem al mati, tarda o nit
		if GAME_DATA.PLAYER.in_bug_contest:
			return CONST.ENCOUNTER_METHODS.BUG_CONTEST
		elif time_of_day == 1 && has_encounter_type("LAND_MORNING"):
			return CONST.ENCOUNTER_METHODS.LAND_MORNING
		elif time_of_day == 2 && has_encounter_type("LAND_DAY"):
			return CONST.ENCOUNTER_METHODS.LAND_DAY
		elif time_of_day == 3 && has_encounter_type("LAND_NIGHT"):
			return CONST.ENCOUNTER_METHODS.LAND_NIGHT
		return CONST.ENCOUNTER_METHODS.LAND
	return null
	
func isCave():
	print(get_children()[0].get_name())
	return get_node("Wild_Pokemon_").get_node("CAVE").get_child_count() > 0
	
func isGrass():
	return has_encounter_type("LAND") or has_encounter_type("LAND_MORNING") or has_encounter_type("LAND_DAY") or has_encounter_type("LAND_NIGHT")

func has_encounter_type(type):
	return get_node("Wild_Pokemon_").get_node(type).get_child_count() > 0
	
