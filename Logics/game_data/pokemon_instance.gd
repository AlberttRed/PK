
extends Node

export(int, "None, Bulbasaur, Ivysaur, Venusaur, Charmander, Charmeleon, Charizard, Squirtle, Wartortle, Blastoise, Caterpie, Metapod, Butterfree, Weedle, Kakuna, Beedrill, Pidgey, Pidgeotto, Pidgeot, Rattata, Raticate, Spearow, Fearow, Ekans, Arbok, Pikachu, Raichu, Sandshrew, Sandslash, Nidoran♀, Nidorina, Nidoqueen, Nidoran♂, Nidorino, Nidoking, Clefairy, Clefable, Vulpix, Ninetales, Jigglypuff, Wigglytuff, Zubat, Golbat, Oddish, Gloom, Vileplume, Paras, Parasect, Venonat, Venomoth, Diglett, Dugtrio, Meowth, Persian, Psyduck, Golduck, Mankey, Primeape, Growlithe, Arcanine, Poliwag, Poliwhirl, Poliwrath, Abra, Kadabra, Alakazam, Machop, Machoke, Machamp, Bellsprout, Weepinbell, Victreebel, Tentacool, Tentacruel, Geodude, Graveler, Golem, Ponyta, Rapidash, Slowpoke, Slowbro, Magnemite, Magneton, Farfetch’d, Doduo, Dodrio, Seel, Dewgong, Grimer, Muk, Shellder, Cloyster, Gastly, Haunter, Gengar, Onix, Drowzee, Hypno, Krabby, Kingler, Voltorb, Electrode, Exeggcute, Exeggutor, Cubone, Marowak, Hitmonlee, Hitmonchan, Lickitung, Koffing, Weezing, Rhyhorn, Rhydon, Chansey, Tangela, Kangaskhan, Horsea, Seadra, Goldeen, Seaking, Staryu, Starmie, Mr. Mime, Scyther, Jynx, Electabuzz, Magmar, Pinsir, Tauros, Magikarp, Gyarados, Lapras, Ditto, Eevee, Vaporeon, Jolteon, Flareon, Porygon, Omanyte, Omastar, Kabuto, Kabutops, Aerodactyl, Snorlax, Articuno, Zapdos, Moltres, Dratini, Dragonair, Dragonite, Mewtwo")var pkm_id = 0
var nickname = "" setget set_nick,get_nick
export(int, 100)var level = 1
export(int, "Macho, Hembra, Sin Genero") var gender = CONST.GENEROS.MACHO setget set_gender,get_gender
export(int)var hp = 0
export(int)var max_hp : int = 0 setget set_hp,get_hp
var status = CONST.STATUS.OK
var attack : int setget set_attack,get_attack
var speed : int setget set_speed,get_speed
var defense : int setget set_defense,get_defense
var special_attack : int setget set_special_attack,get_special_attack
var special_defense : int setget set_special_defense,get_special_defense
var dni = 45645634567
var original_trainer = ""
var expecience = 0
var to_next_level = 250
var effectsFlags = []

export(int, 252)var hp_EVs = 0
export(int, 252)var attack_EVs = 0
export(int, 252)var spAttack_EVs = 0
export(int, 252)var defense_EVs = 0
export(int, 252)var spDefense_EVs = 0
export(int, 252)var speed_EVs = 0

export(int, 31)var hp_IVs = 0
export(int, 31)var attack_IVs = 0
export(int, 31)var spAttack_IVs = 0
export(int, 31)var defense_IVs = 0
export(int, 31)var spDefense_IVs = 0
export(int, 31)var speed_IVs = 0
#IMPORTANT -- S'ha de sumar 1 l'ability_id ja que comença per 0
export(int, "NONE, HEDOR , LLOVIZNA , IMPULSO , ARMADURA_BATALLA , ROBUSTEZ , HUMEDAD , FLEXIBILIDAD , VELO_ARENA , ELEC_ESTATICA , ABSORBE_ELEC , ABSORBE_AGUA , DESPISTE , ACLIMATACION , OJO_COMPUESTO , INSOMNIO , CAMBIO_COLOR , INMUNIDAD , ABSORBE_FUEGO , POLVO_ESCUDO , RITMO_PROPIO , VENTOSAS , INTIMIDACION , SOMBRA_TRAMPA , PIEL_TOSCA , SUPERGUARDA , LEVITACION , EFECTO_ESPORA , SINCRONIA , CUERPO_PURO , CURA_NATURAL , PARARRAYOS , DICHA , NADO_RAPIDO , CLOROFILA , ILUMINACION , RASTRO , POTENCIA , PUNTO_TOXICO , FOCO_INTERNO , ESCUDO_MAGMA , VELO_AGUA , IMAN , INSONORIZAR , CURA_LLUVIA , CHORRO_ARENA , PRESION , SEBO , MADRUGAR , CUERPO_LLAMA , FUGA , VISTA_LINCE , CORTE_FUERTE , RECOGIDA , AUSENTE , ENTUSIASMO , GRAN_ENCANTO , MAS , MENOS , PREDICCION , VISCOSIDAD , MUDAR , AGALLAS , ESCAMA_ESPECIAL , LODO_LIQUIDO , ESPESURA , MAR_LLAMAS , TORRENTE , ENJAMBRE , CABEZA_ROCA , SEQUIA , TRAMPA_ARENA , ESPIRITU_VITAL , HUMO_BLANCO , ENERGIA_PURA , CAPARAZON , BUCLE_AIRE , TUMBOS , ELECTROMOTOR , RIVALIDAD , IMPASIBLE , MANTO_NIVEO , GULA , IRASCIBLE , LIVIANO , IGNIFUGO , SIMPLE , PIEL_SECA , DESCARGA , PUNO_FERREO , ANTIDOTO , ADAPTABLE , ENCADENADO , HIDRATACION , PODER_SOLAR , PIES_RAPIDOS , NORMALIDAD , FRANCOTIRADOR , MURO_MAGICO , INDEFENSO , REZAGADO , EXPERTO , DEFENSA_HOJA , ZOQUETE , ROMPEMOLDES , AFORTUNADO , RESQUICIO , ANTICIPACION , ALERTA , IGNORANTE , CROMOLENTE , FILTRO , INICIO_LENTO , INTREPIDO , COLECTOR , GELIDO , ROCA_SOLIDA , NEVADA , RECOGEMIEL , CACHEO , AUDAZ , MULTITIPO , DON_FLORAL , MAL_SUENO , HURTO , POTENCIA_BRUTA , RESPONDON , NERVIOSISMO , COMPETITIVO , FLAQUEZA , CUERPO_MALDITO , ALMA_CURA , COMPIESCOLTA , ARMADURA_FRAGIL , METAL_PESADO , METAL_LIVIANO , COMPENSACION , IMPETU_TOXICO , IMPETU_ARDIENTE , COSECHA , TELEPATIA , VELETA , FUNDA , TOQUE_TOXICO , REGENERACION , SACAPECHO , IMPETU_ARENA , PIEL_MILAGRO , CALCULO_FINAL , ILUSION , IMPOSTOR , ALLANAMIENTO , MOMIA , AUTOESTIMA , JUSTICIERO , COBARDIA , ESPEJO_MAGICO , HERBIVORO , BROMISTA , PODER_ARENA , PUNTA_ACERO , MODO_DARUMA , TINOVICTORIA , TURBOLLAMA , TERRAVOLTAJE , VELO_AROMA , VELO_FLOR , CARRILLO , MUTATIPO , PELAJE_RECIO , PRESTIDIGITADOR , ANTIBALAS , TENACIDAD , MANDIBULA_FUERTE , PIEL_HELADA , VELO_DULCE , CAMBIO_TACTICO , ALAS_VENDAVAL , MEGADISPARADOR , MANTO_FRONDOSO , SIMBIOSIS , GARRA_DURA , PIEL_FEERICA , BABA , PIEL_CELESTE , AMOR_FILIAL , AURA_OSCURA , AURA_FEERICA , ROMPEAURA , MAR_DEL_ALBOR , TIERRA_DEL_OCASO , RAFAGA_DELTA , FIRMEZA , HUIDA , RETIRADA , HIDRORREFUERZO , ENSANAMIENTO , ESCUDO_LIMITADO , VIGILANTE , POMPA , ACERO_TEMPLADO , COLERA , QUITANIEVES , REMOTO , VOZ_FLUIDA , PRIMER_AUXILIO , PIEL_ELECTRICA , COLA_SURF , BANCO , DISFRAZ , FUERTE_AFECTO , AGRUPAMIENTO , CORROSION , LETARGO_PERENNE , REGIA_PRESENCIA , REVES , PAREJA_DE_BAILE , BATERIA , PELUCHE , CUERPO_VIVIDO , CORANIMA , RIZOS_REBELDES , RECEPTOR , REACCION_QUIMICA , ULTRAIMPULSO , SISTEMA_ALFA , ELECTROGENESIS , PSICOGENESIS , NEBULOGENESIS , HERBOGENESIS , GUARDIA_METALICA , GUARDIA_ESPECTRO , ARMADURA_PRISMA ")var ability_id setget set_ability,get_ability
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
var battle_position
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

func _init():
	add_user_signal("hp_updated")
	
func _ready():
	# Initialization here
	pass

func get_name():
	return DB.pokemons[pkm_id].Name
	
func get_level():
	return level

func get_actual_hp():
	return hp
	
func set_hp(value):
	max_hp = (((2.0*float(value)+float(hp_IVs)+(float(hp_EVs)/4.0))*float(level))/100.0)+float(level)+10.0

func get_hp():
	return max_hp
	
func set_attack(value):
	attack = (((2.0*float(value)+float(attack_IVs)+(float(attack_EVs)/4.0))*float(level))/100.0)+5.0
	
func get_attack():
	return attack
	
func set_special_attack(value):
	special_attack = (((2.0*float(value)+float(spAttack_IVs)+(float(spAttack_EVs)/4.0))*float(level))/100.0)+5.0
	
func get_special_attack():
	return special_attack
	
func set_defense(value):
	defense = (((2.0*float(value)+float(defense_IVs)+(float(defense_EVs)/4.0))*float(level))/100.0)+5.0
	
func get_defense():
	return defense
	
func set_special_defense(value):
	special_defense = (((2.0*float(value)+float(spDefense_IVs)+(float(spDefense_EVs)/4.0))*float(level))/100.0)+5.0
	
func get_special_defense():
	return special_defense
	
func set_speed(value):
	speed = (((2.0*float(value)+float(speed_IVs)+(float(speed_EVs)/4.0))*float(level))/100.0)+5.0
	
func get_speed():
	return speed
	
func set_nick(value):
	nickname = value
	
func get_gender():
	return gender

func set_gender(_gender):
	gender = _gender
	
func get_ability():
	return ability_id

func set_ability(_ability):
	ability_id = _ability

func get_nick():
	if (nickname == ""):
		return DB.pokemons[pkm_id].Name
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
	hp_bar.update_health(damage)
	yield(hp_bar, "hp_updated")
	emit_signal("hp_updated")
	
		
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
	
func hasMove(move_id):
	for m in movements:
		if m.id == move_id:
			return true
	print("has move " + DB.moves[move_id].Name + "?")
	return false

func is_type(type): return type == "Pokemon" or .is_type(type)
func    get_type(): return "Pokemon"