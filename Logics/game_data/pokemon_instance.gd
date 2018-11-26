
extends Node

export(int, "None, Bulbasaur, Ivysaur, Venusaur, Charmander, Charmeleon, Charizard, Squirtle, Wartortle, Blastoise, Caterpie, Metapod, Butterfree, Weedle, Kakuna, Beedrill, Pidgey, Pidgeotto, Pidgeot, Rattata, Raticate, Spearow, Fearow, Ekans, Arbok, Pikachu, Raichu, Sandshrew, Sandslash, Nidoran♀, Nidorina, Nidoqueen, Nidoran♂, Nidorino, Nidoking, Clefairy, Clefable, Vulpix, Ninetales, Jigglypuff, Wigglytuff, Zubat, Golbat, Oddish, Gloom, Vileplume, Paras, Parasect, Venonat, Venomoth, Diglett, Dugtrio, Meowth, Persian, Psyduck, Golduck, Mankey, Primeape, Growlithe, Arcanine, Poliwag, Poliwhirl, Poliwrath, Abra, Kadabra, Alakazam, Machop, Machoke, Machamp, Bellsprout, Weepinbell, Victreebel, Tentacool, Tentacruel, Geodude, Graveler, Golem, Ponyta, Rapidash, Slowpoke, Slowbro, Magnemite, Magneton, Farfetch’d, Doduo, Dodrio, Seel, Dewgong, Grimer, Muk, Shellder, Cloyster, Gastly, Haunter, Gengar, Onix, Drowzee, Hypno, Krabby, Kingler, Voltorb, Electrode, Exeggcute, Exeggutor, Cubone, Marowak, Hitmonlee, Hitmonchan, Lickitung, Koffing, Weezing, Rhyhorn, Rhydon, Chansey, Tangela, Kangaskhan, Horsea, Seadra, Goldeen, Seaking, Staryu, Starmie, Mr. Mime, Scyther, Jynx, Electabuzz, Magmar, Pinsir, Tauros, Magikarp, Gyarados, Lapras, Ditto, Eevee, Vaporeon, Jolteon, Flareon, Porygon, Omanyte, Omastar, Kabuto, Kabutops, Aerodactyl, Snorlax, Articuno, Zapdos, Moltres, Dratini, Dragonair, Dragonite, Mewtwo")var pkm_id = 0
var nickname = "" setget set_nick,get_nick
export(int)var level = 1
var hp
var max_hp setget set_hp,get_hp
var status = CONST.STATUS.OK
var attack setget set_attack,get_attack
var speed setget set_speed,get_speed
var defense setget set_defense,get_defense
var special_attack setget set_special_attack,get_special_attack
var special_defense setget set_special_defense,get_special_defense
var dni = 45645634567
var original_trainer = ""
var expecience = 0
var to_next_level = 250
var effectsFlags = []

export(int)var hp_EVs = 0
export(int)var attack_EVs = 0
export(int)var spAttack_EVs = 0
export(int)var defense_EVs = 0
export(int)var spDefense_EVs = 0
export(int)var speed_EVs = 0

export(int)var hp_IVs = 0
export(int)var attack_IVs = 0
export(int)var spAttack_IVs = 0
export(int)var defense_IVs = 0
export(int)var spDefense_IVs = 0
export(int)var speed_IVs = 0

export(int)var ability_id
export(int)var nature_id
export(int)var held_item_id

var ally
var enemies = []
var base
var node
var hp_bar
var in_battle = false
var front_single_position = CONST.BATTLE.FRONT_SINGLE_SPRITE_POS
var back_single_position =  CONST.BATTLE.BACK_SINGLE_SPRITE_POS
var battle_double_position
var pokeball_node
#class move_instance:
#	var id = 1
#	var pp = 5
#	var max_pp = 5
#	var mod_pp = 0
#	func get_name():
#		return DB.moves[id].Name
#	func get_power():
#		return DB.moves[id].power
#	func get_acuracy():
#		return DB.moves[id].acuracy
#	func get_type():
#		return DB.types[DB.moves[id].type]
#	func get_type_name():
#		return DB.types[DB.moves[id].type].Name
#	func doMove():
#		DB.moves[id].doMove()

var movements = []

var mod_attack = 0
var mod_defense = 0
var mod_speed = 0
var mod_hp = 0
var mod_special = 0

func _ready():
	# Initialization here
	pass
	
func get_actual_hp():
	return hp
	
func set_hp(value):
	max_hp = (((2.0*float(value)+float(hp_IVs)+(float(hp_EVs)/4.0))*float(level))/100.0)+float(level)+10.0

func get_hp():
	return int(max_hp)
	
func set_attack(value):
	attack = (((2.0*float(value)+float(attack_IVs)+(float(attack_EVs)/4.0))*float(level))/100.0)+5.0
	
func get_attack():
	return int(attack)
	
func set_special_attack(value):
	special_attack = (((2.0*float(value)+float(spAttack_IVs)+(float(spAttack_EVs)/4.0))*float(level))/100.0)+5.0
	
func get_special_attack():
	return int(special_attack)
	
func set_defense(value):
	defense = (((2.0*float(value)+float(defense_IVs)+(float(defense_EVs)/4.0))*float(level))/100.0)+5.0
	
func get_defense():
	return int(defense)
	
func set_special_defense(value):
	special_defense = (((2.0*float(value)+float(spDefense_IVs)+(float(spDefense_EVs)/4.0))*float(level))/100.0)+5.0
	
func get_special_defense():
	return int(special_defense)
	
func set_speed(value):
	speed = (((2.0*float(value)+float(speed_IVs)+(float(speed_EVs)/4.0))*float(level))/100.0)+5.0
	
func get_speed():
	return int(speed)

func set_nick(value):
	nickname = value

func get_nick():
	if (nickname == ""):
		return DB.pokemons[pkm_id].name
	else:
		return nickname
		
func print_pokemon():
	print("----------- " + get_nick() + " Nv. " + str(level) + " -----------")
	print("HP: " + str(get_hp()))
	print("ATTACK: " + str(get_attack()))
	print("DEFENSE: " + str(get_defense()))
	print("SP. ATTACK: " + str(get_special_attack()))
	print("SP. DEFENSE: " + str(get_special_defense()))
	print("SPEED: " + str(get_speed()))
	
func update_HP(damage):
	hp_bar.set_health(damage)
	yield(hp_bar, "hp_updated")
	
	
		
#func get_attack():
#	return DB.pokemons[pkm_id].attack
#
#func get_speed():
#	return DB.pokemons[pkm_id].speed
#
#func get_defense():
#	return DB.pokemons[pkm_id].defense
#
#func get_special_attack():
#	return DB.pokemons[pkm_id].special_attack
#
#func get_special_defense():
#	return DB.pokemons[pkm_id].special_defense

func get_type1():
	return DB.pokemons[pkm_id].type_a
	
func get_type2():
	return DB.pokemons[pkm_id].type_b
	
func get_types():
	return [DB.pokemons[pkm_id].type_a, DB.pokemons[pkm_id].type_b]
	
func is_status(s):
	return status == s
	
func hasWorkingAbility(a):
	return ability_id == a

func hasWorkingEffect(e):
	return effectsFlags.has(e)
	
func hasAlly():
	return ally != null
	
func hasFullHealth():
	return hp == max_hp

func is_type(type): return type == "Pokemon" or .is_type(type)
func    get_type(): return "Pokemon"