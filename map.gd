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

export(AudioStream) var music

var tile_offset = Vector2(0, 0)
var N
#export(Array, Array) var pkmn_Land
#export(Array, int) var pkmn_LandMorning
#export(Array, int) var pkmn_LandDay
#export(Array, int) var pkmn_LandNight
#export(Array, int) var pkmn_Cave
#export(Array, int) var pkmn_BugContest 
#export(Array, int) var pkmn_RockSmash 
#export(Array, int) var pkmn_OldRod 
#export(Array, int) var pkmn_GoodRod 
#export(Array, int) var pkmn_SuperRod 
#export(Array, int) var pkmn_HeadbuttLow
#export(Array, int) var pkmn_HeadbuttHigh

var Player = GAME_DATA.PLAYER 
var world = ProjectSettings.get("Global_World")
var comptador = 0
export(NodePath) var map_area
onready var wild_pokemon = get_node("Wild_Pokemon_")
export(int) var land_density = 30

var area
var loaded = false
var strength_on = false

func init():
	
	comptador += 1
	world.get_node("CanvasModulate/CapaTerra_").z_index = -2
	print("Map init count: " + str(comptador))
	#ProjectSettings.set("Previous_Map", ProjectSettings.get("Actual_Map"))
	GAME_DATA.PREVIOUS_MAP = GAME_DATA.ACTUAL_MAP
	GAME_DATA.ACTUAL_MAP = self
	#ProjectSettings.set("Actual_Map", self)	

func _init():
	#N = N_connection.instance()
	add_user_signal("loaded")
	add_user_signal("connected")
#	if Player.get_parent() != null:
#		Player.get_parent().remove_child(Player)
#		target.get_node("CanvasModulate/Eventos_").add_child(Player)
	
func set_connections():
	var Scene
	if N_connection != null and N_connection_pos != null:
		print("NNNNNNNNNNNNNNNNNNNNN " + self.get_name())
		Scene = N_connection
		var scene_name = N_connection.get_path().split("/")[4].split(".")[0]
		if world.get_parent().get_tree().get_nodes_in_group(scene_name).size() <= 0:		
			print("N connected: " + str(scene_name))#str(N_connection.split("/")[3].split(".")[0]))
			call_deferred("load_map", false, Scene.instance(), N_connection_pos)
	if !S_connection.empty() and S_connection_pos != null:
		print("SSSSSSSSSSSSSSSSSSSSS")
		Scene = load(S_connection).instance()
		if world.get_parent().get_tree().get_nodes_in_group(Scene.get_name()).size() <= 0:		
			print("S connected: " + str(Scene.get_name()))
			load_map(false, Scene, S_connection_pos)
	if !E_connection.empty() and E_connection_pos != null:
		print("EEEEEEEEEEEEEEEEEEEEEE")
		Scene = load(E_connection).instance()
		if world.get_parent().get_tree().get_nodes_in_group(Scene.get_name()).size() <= 0:		
			print("E connected: " + str(Scene.get_name()))
			load_map(false, Scene, E_connection_pos)
	if !W_connection.empty() and W_connection_pos != null:
		print("WWWWWWWWWWWWWWWWWWWWWWWW")
		Scene = load(W_connection).instance()
		if world.get_parent().get_tree().get_nodes_in_group(Scene.get_name()).size() <= 0:		
			print("W connected: " + str(Scene.get_name()))
			load_map(false, Scene, W_connection_pos)

		
func load_map(deletePrevious, scene = self, pos = null):
	#print("Loaded Map: " + scene.get_name())

	init()


#	if pos != null:
#		print("set " + scene.get_name() + " tile offset: " + str(-pos))
#		scene.tile_offset = -pos

	

#		world.add_child(scene)
#		scene.set_position(pos)
#		var capa = scene.get_node("CapaTerra_")
#		scene.remove_child(capa)
#		world.get_node("CanvasModulate").get_node(capa.get_name().split("_")[0].replace("@", "") + "_").add_child(capa)
#		capa.add_to_group(scene.get_name())

		
	strength_on = false
	
	for N in scene.get_children() :		
		if !N.is_in_group("ignore"):
			#print("N tratada: " + N.get_name())
			N.add_to_group(scene.get_name())

			if (N.get_name().split("_")[0].replace("@", "") + "_") == "MapArea_":
				N.parent_map = scene

			scene.remove_child(N)
			world.get_node("CanvasModulate").get_node(N.get_name()).add_child(N)
			N.set_owner(world.get_node("CanvasModulate").get_node(N.get_name().split("_")[0].replace("@", "") + "_"))
	
		#			if pos != null:
#				N.set_position(pos)
#			else:
#				if (N.get_name().split("_")[0].replace("@", "") + "_") == "MapArea_" or (N.get_name().split("_")[0].replace("@", "") + "_") == "Areas_":# and scene == self:
#					N.set_position(area_pos)
#				else:
#					N.set_position(scene.get_position())

	for evento in world.get_node("CanvasModulate/Eventos_/Eventos_").get_children():
			#var position = evento.get_position()
			evento.add_to_group(scene.get_name())
			world.get_node("CanvasModulate/Eventos_/Eventos_").remove_child(evento)
			world.get_node("CanvasModulate/Eventos_").add_child(evento)
			evento.set_owner(world.get_node("CanvasModulate/Eventos_"))
					#evento.set_position(position)
	world.get_node("CanvasModulate/Eventos_").remove_child(world.get_node("CanvasModulate/Eventos_/Eventos_"))
#	for encounter_area in target.get_node("CanvasModulate/EncounterAreas_/EncounterAreas_").get_children():
#		encounter_area.add_to_group(scene.get_name())
	if pos != null:
		reposition(scene, pos)	
	if scene == self:
		if Player.get_parent() != null:
			Player.get_parent().remove_child(Player)
		world.get_node("CanvasModulate/Eventos_").add_child(Player)
	loaded = true
	
	
#	print("DELETE SCENE : " + scene.get_name())
#	for c in scene.get_children():
#		print("scene child: " + c.get_name())
	#world.remove_child(scene)
	if deletePrevious:
		GLOBAL.destroy(GAME_DATA.PREVIOUS_MAP)
		#GLOBAL.destroy(ProjectSettings.get("Previous_Map"))
	emit_signal("loaded")
		
func get_area(tree):
	for n in tree.get_nodes_in_group(get_name()):
		if n.get_name() == "MapArea_":
			return n
	return null
#		for node in get_tree().get_nodes_in_group(ProjectSettings.get("Previous_Map").get_name()):
#			if node.get_name() != "Eventos_" and node != get_parent().get_parent().get_parent():
#				node.call_deferred("free")
#			elif node == get_parent().get_parent().get_parent():
#				node.hide()
		#Player.set_position(Vector2(-16, -48))
		
#				var position_ev = evento.get_position()
#				N.remove_child(evento)
#				target.get_node("CanvasModulate").get_node(N.get_name()).add_child(evento)
#				evento.set_owner(target.get_node("CanvasModulate").get_node(N.get_name().split("_")[0].replace("@", "") + "_"))


#				if pos != null:
#					N.set_position(pos)
#				else:
				#N.set_position(scene.get_position()				evento.set_position(position_ev)
func save():
	var game_data = {
		"filename" : get_filename(),
		"strength_on" : strength_on # Vector2 is not supported by JSON
	}
	return game_data

				
				
func reposition(scene, pos):
	#print("set " + scene.get_name() + " tile offset: " + str(-pos))
	scene.tile_offset = -pos
	#print(str(get_children()))
	#print("scene position: " + str(scene.get_position()))
	for c in world.get_node("CanvasModulate").get_children():
	#	print(c.get_name() + " selected")
		for n in c.get_children():
			#print("childs: " + str(n.get_name()) + " " + str(n.get_groups()))
			if n.get_class() != "Node" and n.get_class() != "AnimationPlayer" and n.get_class() != "Tween": 
				if n.is_in_group(scene.get_name()):
				#	print(n.get_name() + " repositioned")
				#	print("Before " + str(n.get_position()))
					n.set_position(n.get_position() + pos)
				#	print("After " + str(n.get_position()))


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
	
#	var selected_method = ProjectSettings.get("Actual_Map").get_node("wild_pokemon").get_child(encounter_method)
#	if encounter_method == CONST.ENCOUNTER_METHODS.LAND_MORNING or encounter_method ==  CONST.ENCOUNTER_METHODS.LAND_DAY or encounter_method ==  CONST.ENCOUNTER_METHODS.LAND_NIGHT:
#		if selected_method.get_children().size() == 0:
#			return ProjectSettings.get("Player").wild_pokemon.get_child(CONST.ENCOUNTER_METHODS.LAND)
#		else:
#			return selected_method
#	else:
#		return selected_method

func isCave():
	print(get_children()[0].get_name())
	return get_node("Wild_Pokemon_").get_node("CAVE").get_child_count() > 0
	
func isGrass():
	return has_encounter_type("LAND") or has_encounter_type("LAND_MORNING") or has_encounter_type("LAND_DAY") or has_encounter_type("LAND_NIGHT")

func has_encounter_type(type):
	return get_node("Wild_Pokemon_").get_node(type).get_child_count() > 0
	
func _on_Area2D__area_shape_entered(area_id, _area, area_shape, self_shape):
	pass # Replace with function body.
