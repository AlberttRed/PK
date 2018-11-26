extends Node

var MOVE_FUNCTIONS = load("res://ui/battle/BATTLE_MoveFunctions.gd").new()
var MOVE_ANIMATIONS = load("res://ui/battle/BATTLE_MoveAnimations.gd").new()

export(String) var internal_name = ""
export(String) var Name = "" # the resource name e.g. Overgrow.
export(int) var id = 0 # the id of the resource.
export(String,MULTILINE) var description = "" # a description of the move.
export(int,"None, Normal, Fighting, Flying, Poison, Ground, Rock, Bug, Ghost, Steel, Fire, Water, Grass, Electric, Psychic, Ice, Dragon, Dark, Fairy") var type = 1
export(int) var power = 0 # the power of the move.
export(int) var accuracy = 0 # the accuracy of the move.
export(int) var pp = 0 # the pp points of the move.
export(int) var effect_chance = null # % de que un atac pugui produir un problema d estat(cremar, confuso etc)
export(int) var priority = 0 # % de que un atac pugui produir un problema d estat(cremar, confuso etc)
export(int, "None, Estado, Físico, Especial") var damage_class_id = 5 # % de que un atac pugui produir un problema d estat(cremar, confuso etc)
export(String,MULTILINE) var effect_entries = "" # Explicacio de com es produeix l atac. Ho faré servir per quan fagi els scripts dels atacs
export(Array) var stat_change_ids = [] # id de l'estat que es modifica
export(Array) var stat_change_valors = [] #numero de stages que baixa o puja l stat (-2 = baixa dos stages)
export(int) var target_id = 1 # la id del target de l atac. Si ataca al rival, o pot atacar a dos a lhora, o a un aliat, o a tots els q hi ha en combat...
export(int) var meta_ailment_id = null # la id del tipus de ailment que pot provocar el mov.(cremar, paralitzar etc)
export(int) var meta_category_id = 1 # la id de l'"efecte" que provoca el moviment. si fa mal, si fa mal i pot cremar, si cura etc.
export(int) var meta_min_hits = 1 #numero minim de cops q fa l atac en un turn. si només fa un és null
export(int) var meta_max_hits = 1 #numero maxim de cops q fa l atac en un turn. si només fa un és null
export(int) var meta_min_turns = 1 #numero minim de truns q dura o es repeteix l atac. si només dura un és null
export(int) var meta_max_turns = 1 #numero maxim de truns q dura o es repeteix l atac. si només dura un és null
export(int) var meta_drain = 0 #numero de ps que et cura o et treu l atac. (drenadoras cura, per tant sera valor positiu, si estas enverinat et treu, per tant sera valor negatiu)
export(int) var meta_healing = 0 # % de vida que es cura l atacant fent el mov. segons el seu total de ps
export(int) var meta_crit_rate = 0 # ratio de que l atac pugui provocar un cop critic
export(int) var meta_ailment_chance = 0 # % de que el mov. provoqui ailment
export(int) var meta_flinch_chance = 0 # % de que un atac fagi retrocedir  al rival
export(int) var meta_stat_chance = 0 # % de que un atac pugi o baixi els stats
export(bool) var contact_flag = false
export(int) var move_effect = 1 #id de la funció que s'ocupa de calcular el mal d'aquest moviment
#var functions = MOVE_FUNCTIONS.hola()

func doMove(move,from,to):
#	var ran = 0.85
#	var damages = ""
#	while ran < 1.01:
#		damages = damages + str(get_damage(from,to,ran)) + ", "
#		ran = ran + 0.01
#	print(damages)
	to.update_HP(-get_damage(from,to))
	MOVE_FUNCTIONS.functions["Move_Function" + str(self.move_effect).pad_zeros(3)].new().ApplyDamage(move,from,to)
	
func ShowAnimation(from,to):	
	MOVE_ANIMATIONS.animations["Move_Animation" + str(self.move_effect).pad_zeros(3)].new().ShowAnimation(from,to)
	
func is_special():
	return damage_class_id == CONST.DAMAGE_CLASS.ESPECIAL
	
func has_target(target):
	return target_id == target
	
func has_multiple_targets(from):
	if from.enemies.size() == 2:
		if has_target(CONST.TARGETS.BASE_ENEMY) or has_target(CONST.TARGETS.ALL_OTHER) or has_target(CONST.TARGETS.ENEMIES) or has_target(CONST.TARGETS.ALL_FIELD) or has_target(CONST.TARGETS.ALL_POKEMON) or has_target(CONST.TARGETS.PLAYERS) or has_target(CONST.TARGETS.BASE_PLAYER):
			return true
		else:
			return false
	else:
		return false
		
func is_type(t):
	return type == t
	
func hasWorkingMoveEffect(e):
	return move_effect == e
	
func makeContact():
	return contact_flag

	
func get_damage(from,to,r = null):
	var Damage
	var Modifier
	var Att = from.get_attack()
	var Def = to.get_defense()
	var STAB = 1.0
	var Ef = DB.types[self.type].get_effectiveness_against(to.get_type1())
	var random
	var Targets = 1.0
	var Weather = 1.0
	var Critical = 1.0 # TO DO
	var Burn = 1.0
	var Other = 1.0
	if self.is_special():
		Att = from.get_special_attack()
		Def = to.get_special_defense()
		
	if self.has_multiple_targets(from):
		Targets = 0.75
	
	if GUI.battle.hasWorkingWeather(CONST.WEATHER.LLUVIOSO):
		if self.is_type(CONST.TYPES.FUEGO):
			Weather = 0.5
		elif self.is_type(CONST.TYPES.AGUA):
			Weather = 1.5
	elif GUI.battle.hasWorkingWeather(CONST.WEATHER.SOLEADO):
		if self.is_type(CONST.TYPES.FUEGO):
			Weather = 1.5
		elif self.is_type(CONST.TYPES.AGUA):
			Weather = 0.5
		
	if from.get_types().has(type) and from.hasWorkingAbiltity(CONST.ABILITIES.ADAPTABLE):
		STAB = 2
	elif from.get_types().has(type) and !from.hasWorkingAbiltity(CONST.ABILITIES.ADAPTABLE):
		STAB = 1.5
		
	if from.is_status(CONST.STATUS.BURNT) and !from.hasWorkingAbiltity(CONST.ABILITIES.AGALLAS) and (!self.is_special() and self.hasWorkingMoveEffect(CONST.MOVE_EFFECTS.IMAGEN)):
		Burn = 0.5
		
	if to.get_type2() != CONST.TYPES.NONE:
		Ef = Ef * DB.types[type].get_effectiveness_against(to.get_type2())
		
	if r == null:
		randomize()
		random = 1.0#rand_range(0.85, 1.01)
	else:
		random = r
		
	Other = calculate_others(from,to,Ef,false)

	Damage = int(int((int((2.0 * float(from.level))/5.0 + 2.0) * float(power) * float(Att))/float(Def))/50.0 + 2.0) #(((2 * from.level/5 + 2) * power * Att/Def)/50 + 2)
	#print("Level: " + str(from.level) + ", Power: " + str(power) + ", Attack: " + str(Att) + ", Def: " + str(Def))
	
	#print("Targets: " + str(Targets) + ", Weather: " + str(Weather) + ", Critical: " + str(Critical) + ", Random: " + str(random) + ", STAB: " + str(STAB) + ", Ef: " + str(Ef) + ", Burn: " + str(Burn) + ", Other: " + str(Other))
	var result = int(int(int(int(int(int(int(int(Damage*Targets) * Weather) * Critical) * random) * STAB) * Ef) * Burn) * Other)

	if result == 0:
		result = 1
	return result
	
func calculate_others(from,to,Type,critical):
	var value = 1.0

	### MOVES
	if to.base.hasWorkingFieldEffect(CONST.MOVE_EFFECTS.VELO_AURORA) and !critical and !from.hasWorkingAbility(CONST.MOVE_EFFECTS.ALLANAMIENTO):
		value *= 0.5
		
	if (self.hasWorkingMoveEffect(CONST.MOVE_EFFECTS.GOLPE_CUERPO) or self.hasWorkingMoveEffect(CONST.MOVE_EFFECTS.CARGA_DRAGON) or self.hasWorkingMoveEffect(CONST.MOVE_EFFECTS.CUERPO_PESADO) or self.hasWorkingMoveEffect(CONST.MOVE_EFFECTS.PLANCHA_VOLADORA) or self.hasWorkingMoveEffect(CONST.MOVE_EFFECTS.GOLPE_CALOR) or self.hasWorkingMoveEffect(CONST.MOVE_EFFECTS.PISOTON)) and to.hasWorkingEffect(CONST.MOVE_EFFECTS.REDUCCION):
		value *= 2.0
		
	if (self.hasWorkingMoveEffect(CONST.MOVE_EFFECTS.TERREMOTO) or self.hasWorkingMoveEffect(CONST.MOVE_EFFECTS.MAGNITUD)) and to.hasWorkingEffect(CONST.MOVE_EFFECTS.EXCAVAR):
		value *= 2.0

	if (self.hasWorkingMoveEffect(CONST.MOVE_EFFECTS.SURF) or self.hasWorkingMoveEffect(CONST.MOVE_EFFECTS.TORBELLINO)) and to.hasWorkingEffect(CONST.MOVE_EFFECTS.BUCEO):
		value *= 2.0
	
	if !to.base.hasWorkingFieldEffect(CONST.MOVE_EFFECTS.VELO_AURORA) and to.base.hasWorkingFieldEffect(CONST.MOVE_EFFECTS.PANTALLA_LUZ) and !critical and !from.hasWorkingAbility(CONST.MOVE_EFFECTS.ALLANAMIENTO):
		value *= 0.5

	if !to.base.hasWorkingFieldEffect(CONST.MOVE_EFFECTS.VELO_AURORA) and to.base.hasWorkingFieldEffect(CONST.MOVE_EFFECTS.REFLEJO) and !critical and !from.hasWorkingAbility(CONST.MOVE_EFFECTS.ALLANAMIENTO):
		value *= 0.5
	
	### ABILITIES
	
	if to.hasWorkingAbility(CONST.ABILITIES.PELUCHE) and self.makeContact() and !self.is_type(CONST.TYPES.FUEGO):
		value *= 0.5
	elif to.hasWorkingAbility(CONST.ABILITIES.PELUCHE) and !self.makeContact() and self.is_type(CONST.TYPES.FUEGO):
		value *= 2.0
		
	if to.hasWorkingAbility(CONST.ABILITIES.FILTRO) and Type > 1:
		value *= 0.75
	
	if from.hasAlly() and from.ally.hasWorkingAbility(CONST.ABILITIES.COMPIESCOLTA):
		value *= 0.75
		
	if to.hasWorkingAbility(CONST.ABILITIES.COMPENSACION) and to.hasFullHealth():
		value *= 0.50
		
	if to.hasWorkingAbility(CONST.ABILITIES.ARMADURA_PRISMA) and Type > 1:
		value *= 0.75
		
	if to.hasWorkingAbility(CONST.ABILITIES.GUARDIA_ESPECTRO) and to.hasFullHealth():
		value *= 0.50
		
	if from.hasWorkingAbility(CONST.ABILITIES.FRANCOTIRADOR) and critical:
		value *= 1.50
	
	if to.hasWorkingAbility(CONST.ABILITIES.ROCA_SOLIDA) and Type > 1:
		value *= 0.75
		
	if from.hasWorkingAbility(CONST.ABILITIES.CROMOLENTE) and Type < 1:
		value *= 2.0
	
	return value
	### ITEMS
	