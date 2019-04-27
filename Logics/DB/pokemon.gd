
extends Node

export(int) var id = 0
export(String) var internal_name = ""
export(String) var Name = ""

export(int,"None, Normal, Fighting, Flying, Poison, Ground, Rock, Bug, Ghost, Steel, Fire, Water, Grass, Electric, Psychic, Ice, Dragon, Dark, Fairy") var type_a
export(int,"None, Normal, Fighting, Flying, Poison, Ground, Rock, Bug, Ghost, Steel, Fire, Water, Grass, Electric, Psychic, Ice, Dragon, Dark, Fairy") var type_b


export(int) var base_exprience = 0 #experiencia que guanyes al derrotar aquest pkmn
export(int) var height = 0
export(int) var weight = 0
export(bool) var is_default = true # es la forma per defecte o no? Quan et trobis aquest pkmn en estat salvatge tindrà aquesta forma per defecte
export(Array) var abilities = [null, null, null] #FALTA ENUM
export(Array) var forms = [] # TO DO
export(Array) var held_items_id = [] #llista d objectes q pot portar el pokemon quan l'atrapes
export(Array) var held_items_rarity = [] #probabilitat de que porti aquell objecte

# ------------ MOVES    Només ens interessens els tipus 1,2,3,4, 6, 10
export(Array) var learn_type = []
export(Array) var learn_lvl = []
export(Array) var learn_move_id = []

export(int) var hp = 0
export(int) var attack= 0
export(int) var defense = 0
export(int) var special_attack = 0
export(int) var special_defense = 0
export(int) var speed = 0
export(int) var total = 0

export(int) var hp_effort_EVs = 0
export(int) var attack_effort_EVs= 0
export(int) var defense_effort_EVs = 0
export(int) var special_effort_attack_EVs = 0
export(int) var special_effort_deffense_EVs = 0
export(int) var speed_effort_EVs = 0

export(int) var gender_rate = 0  #probabilitat de que un pokemon sigui mascle o femella al trobarte'l. SI no te sexte = -1
export(int) var capture_rate = 0 #facilitat per atrapar aquest pokemon. El maxim crec q es 255, com més alt sigui el num. mes facil és
export(int) var base_happiness = 0 #Felicitat base que té el pkmn quan l atrapes amb una pokeball normal. El maxim crec q es 255, com més alt sigui el num. mes feicitat tindrà
export(bool) var is_baby = false # si el pkmn es una cria de pkmn o no (ex: magby, elekid)
export(int) var hatch_counter = 0 #Son el cicles de passos necessaris per trancar un ou, cada cicle son 250 passos. 250 x hatch_counter

export(bool) var has_gender_differences = false # indica si l sprite te diferencies entre un sexe i l altre
export(bool) var forms_switchable = false # indica si el pkmn pot transformarse d una forma a una altre durant la partida o combat

export(int) var growth_rate_id = 1 #indica la velocitat en la que puja de nivell(quantitat d experiencia q guanya) aquest pokemon. Hi ha 5/6 nivells, de mes lent a mes rapid.

export(int) var egg_group_a_id #id del grupo huevo 1
export(int) var egg_group_b_id #id del grupo huevo 2

export(Array) var evol_method = [] #CONST.EVOL_LVL_UP
export(Array) var evol_lvl = []
export(Array) var evol_pokemon_id = []

export(String,MULTILINE) var description = ""

export(int) var habitat_id = 1

#export(String) var ev_yield = ""


var poke_instance_script = preload("res://logics/game_data/pokemon_instance.gd")
var move_instance_script = preload("res://logics/game_data/move_instance.gd")

func make_wild(level):
	var p = poke_instance_script.new()
	p.pkm_id = id
	p.nickname = Name
	p.level = level
	p.max_hp=hp
	p.hp = p.max_hp
	p.attack = attack
	p.defense = defense
	p.speed = speed
	p.special_attack = special_attack
	p.special_defense = special_defense
	randomize()
	p.ability_id = get_ability()
	p.dni = 34456547 #TODO:MARIANOGNU: how to generate unique id?
	p.original_trainer = GAME_DATA.player_name
	p.to_next_level = 300 #TODO:MARIANOGNU: how to calculate next level?

	var learnable_indexes = []

	for i in range(learn_move_id.size()):
		if (learn_type[i] == CONST.LEARN_LVL_UP):
			if (learn_lvl[i] <= level):
				learnable_indexes.push_back(i)

	learnable_indexes.sort_custom(self, "move_is_greater")

	if (learnable_indexes.size() > 4):
		var moves = []
		var idx = learnable_indexes.size()-4;
		moves.push_back(learnable_indexes[idx])
		moves.push_back(learnable_indexes[idx+1])
		moves.push_back(learnable_indexes[idx+2])
		moves.push_back(learnable_indexes[idx+3])
		learnable_indexes = moves

	for idx in learnable_indexes:
		var move = move_instance_script.new()
		move.id = 1#learn_move_id[idx]
		move.pp = DB.moves[move.id].pp
		move.max_pp = move.pp
		p.movements.push_back(move)
	return p

func move_is_greater(a, b):
	return learn_lvl[a]<=learn_lvl[b]
	
func get_ability():
	var a = null
	while a == null:
		a = abilities[randi() % abilities.size()]
	return a