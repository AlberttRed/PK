
extends Area2D

export(int,"FIELD, FOREST , CAVE, CAVEDARK, CHAMPION, ELITEA, ELITEB, ELITEC, ELITED, INDOORA, INDOORB, INDOORC, MOUNTAIN, SNOW,UNDERWATER, WATER") var background
export(int,"LAND, LAND_MORINING, LAND_DAY, LAND_NIGHT, CAVE, BUG_CONTEST, ROCK_SMASH, OLD_ROD, GOOD_ROD, SUPER_ROD, HEADBUTT_LOW, HEADBUTT_HIGH") var encounter_method


export var double = false
#var Player = ProjectSettings.get("Player") 
var Player = GAME_DATA.PLAYER
export(float) var density = 25 #Quantitat d'encuentros que apareixen. Com mes alt es el numero, mes sovint.
var Trainer = preload("res://Logics/event/Trainer_class.gd")

var pkmn = []

func _init():
	add_to_group("Encounter_Area")
	add_to_group("Pasable")

func _ready():
#	ProjectSettings.get("Player").update_maparea_exception(self)
	connect("area_entered", self, "on_area_enter")
	connect("area_exited",self, "on_area_exit")
	#pkmn = [pkm_id1,pkm_id2,pkm_id3,pkm_id4,pkm_id5,pkm_id6,pkm_id7,pkm_id8,pkm_id9,pkm_id10]
#	Globals.get("player").add_exeception(self)
#	for mov in get_tree().get_nodes_in_group("movable"):
#		mov.add_exeception(self)

func on_area_enter(area):
	if (area.is_in_group("Player")): #== Globals.get("player")):
		area.connect("move", self, "calculate_encounter")


func on_area_exit(area):
	if (area.is_in_group("Player")):#if (area == Globals.get("player")):
		area.disconnect("move", self, "calculate_encounter")
#
func calculate_encounter():
	var method = select_method()
	if Player.direction.collides_with(self):
		print("moved")
		var rate = rand_range(0,100)
		if (rate <= density):
			var p = int(floor(rand_range(0, method.get_children().size)))
			var chosen_pokemon = method.get_child(p)
			if chosen_pokemon.pkmn_id > 0 && chosen_pokemon.pkmn_id <=751:
				GAME_DATA.PLAYER.can_move = false
				print("found! " + DB.pokemons[chosen_pokemon.pkmn_id].name)
				GUI.play_transition("transition_wild_battle")
				yield(GUI, "finished")
				var wild_pkmns = []
				wild_pkmns.push_back(DB.pokemons[chosen_pokemon.pkmn_id].make_wild(floor(rand_range(chosen_pokemon.min_lvl,chosen_pokemon.max_lvl+1))))
				if double:
					wild_pkmns.push_back(DB.pokemons[chosen_pokemon.pkmn_id].make_wild(floor(rand_range(chosen_pokemon.min_lvl,chosen_pokemon.max_lvl+1))))
				GUI.init_battle(double, GAME_DATA.trainer, Trainer.new("wild", null, null, null, null, null, false, double, false, false, wild_pkmns, false))
# aquest es el bo			GUI.init_battle(GAME_DATA.party[0], DB.pokemons[pkmn[p]].make_wild(floor(rand_range(min_lvl,max_lvl+1))))
			#GUI.wild_encounter(pkmn[p], floor(rand_range(min_lvl,max_lvl+1)))

func select_method():
	var selected_method = ProjectSettings.get("Actual_Map").get_node("wild_pokemon").get_child(encounter_method)
	if encounter_method == CONST.ENCOUNTER_METHODS.LAND_MORNING or encounter_method ==  CONST.ENCOUNTER_METHODS.LAND_DAY or encounter_method ==  CONST.ENCOUNTER_METHODS.LAND_NIGHT:
		if selected_method.get_children().size() == 0:
			return ProjectSettings.get("Player").wild_pokemon.get_child(CONST.ENCOUNTER_METHODS.LAND)
		else:
			return selected_method
	else:
		return selected_method
