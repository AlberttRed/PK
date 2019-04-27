
extends Node

const TEXT_SPEEDS = [0.1,0.15,0.2]

const OPTION_TEXT_FAST=0
const OPTION_TEXT_MEDIUM=1
const OPTION_TEXT_SLOW=2

const EVOL_LVL_UP=0
const EVOL_TRADE=1
const EVOL_STONE=2

const LEARN_LVL_UP=1
const LEARN_EGG_MOVE=2
const LEARN_TUTOR=3
const LEARN_MACHINE=4
const LEARN_LIGHT_BALL_EGG=6
const LEARN_FORM_CHANGE=10

const OPTION_BATTLE_ANIM_ON=0
const OPTION_BATTLE_ANIM_OFF=1

const OPTION_BATTLE_TYPE_SHIFT=0
const OPTION_BATTLE_TYPE_SET=1

const UP=0
const DOWN=1
const LEFT=2
const RIGHT=3

const functions = {}

const Window_StyleBox = preload("res://ui/speech hgss 1.png")

class STATUS:
	const OK = 0
	const SLEEP = 1
	const POISON = 2
	const BURNT = 3
	const PARALISIS = 4
	const FROZEN = 5

class BATTLE:
	# HP bar colors
	const  HPCOLORGREEN = Color("#18c020")#Color(24,192,32)
	const  HPCOLORYELLOW = Color("#f8b000")#Color(248,176,0)
	const  HPCOLORRED = Color("#f85828")#Color(248,88,40)
	
	# Exp bar color
	const EXPCOLORBASE = Color("#4890f8")#Color(72,144,248)
	
	const SINGLE_BALL_POS = Vector2(58, -96)
	const BACK_BALL_POS = Vector2(116, -36)
	const FRONT_SINGLE_BALL_POS = Vector2(126, 60)
	#const DOUBLE2_BALL_POS = Vector2(90, -80)
	
	const FRONT_SINGLE_SPRITE_POS = Vector2(128, -34)
	const FRONT_DOUBLE1_SPRITE_POS = Vector2(96, -50)   #SI HA DE SUMAR EL DOBLE DEL VALOR PLAYERENEMYY DE L ESSENTIALS
	const FRONT_DOUBLE2_SPRITE_POS = Vector2(176, -34)   #SI HA DE SUMAR EL DOBLE DEL VALOR PLAYERENEMYY DE L ESSENTIALS
	
	const BACK_SINGLE_SPRITE_POS = Vector2(156, -16)
	const BACK_DOUBLE1_SPRITE_POS = Vector2(208, -16)   #SI HA DE SUMAR EL DOBLE DEL VALOR PLAYERENEMYY DE L ESSENTIALS
	const BACK_DOUBLE2_SPRITE_POS = Vector2(288, 0)   #SI HA DE SUMAR EL DOBLE DEL VALOR PLAYERENEMYY DE L ESSENTIALS
	
	const BACK_SINGLE_TRAINER_POS = Vector2(192,-80) 
	const BACK_DOUBLE1_TRAINER_POS = Vector2(-144,-80) 
	const BACK_DOUBLE2_TRAINER_POS = Vector2(224,-80) 
	
	const FRONT_SINGLE_TRAINER_POS = Vector2(64,-58) 
	const FRONT_DOUBLE1_TRAINER_POS = Vector2(38, -58)
	const FRONT_DOUBLE2_TRAINER_POS = Vector2(84, -58)
	
	const PLAYER_BASE_POS = Vector2(-128,240)
	const ENEMY_BASE_POS = Vector2(256,112)
	
	const SINGLE_PLAYERHPBAR_INITIALPOSITION = Vector2(396, 236)
	const SINGLE_ENEMYHPBAR_INITIALPOSITION = Vector2(116, 70)
	const SINGLE_PLAYERPARTY_INITIALPOSITION = Vector2(562, 230)
	const SINGLE_ENEMYPARTY_INITIALPOSITION = Vector2(270, 105)
	const SINGLE_PLAYERBASE_INITIALPOSITION = Vector2(-148, 240)
	const SINGLE_ENEMYBASE_INITIALPOSITION = Vector2(257, 111)
	
	const SINGLE_BACK_SLOT = 0
	const DOUBLE_BACK_SLOT_1 = 1
	const DOUBLE_BACK_SLOT_2 = 2
	const SINGLE_FRONT_SLOT = 3
	const DOUBLE_FRONT_SLOT_1 = 4
	const DOUBLE_FRONT_SLOT_2 = 5
	
class DAMAGE_CLASS:
	
	const ESTADO = 1
	const FISICO = 2
	const ESPECIAL = 3
	
class WEATHER:
	const SOLEADO = 1
	const SOL_ABRASADOR = 2
	const LLUVIOSO = 3
	const DILUVIO = 4
	const TORM_ARENA = 5
	const GRANIZO = 6
	const NIEBLA = 7
	const TURBULENCIAS = 8
	const LLUVIA_DIAMANTES = 9
	
class TARGETS:
	const ESPECIFICO = 1 # El Target es selecciona automáticament segons el moviment, son casos especials. Ex: Maldición, Contraataque
	const YO_PRIMERO = 2 # Cas especial per l atac Yo Primero. Es selecciona el pokemon individualment, com un atac normal.
	const ALIADO = 3 # L atac va dirigit per força l aliat del pokemon que executa l atac. Si no té aliat l'atac fallarà. Ex: Refuerzo
	const BASE_PLAYER = 4 # Efecta a la BASE/FIELD. L'atac afecta a tots els pkmn q estàn a la mateixa base que el pkmn atacant. El target serà el mateix pokemon atacant i el seu aliat. Ex: Pantalla Luz
	const USER_OR_ALLY = 5 # El jugador podrà seleccionar l'objectiu entre el propi pokemon atacant i l'aliat. Només un dels dos.
	const BASE_ENEMY = 6 # Efecta a la BASE/FIELD. A la inversa que el BASE_PLAYER, l atac afectarà a TOTS els pokemons q estiguin la base rival. Ex: Púas
	const USER = 7 #Efecte a l'usuari. Només es pot seleccionar el pokemon que fa l'atac. Ex: Danza espada
	const RANDOM_ENEMY = 8 #Efecte a un dels dos pokemons enemics aleatoriament. No pots seleccionar quin. Ex: Combate
	const ALL_OTHER = 9 #L'atac efecte a tots els pokemons sobre el camp de batalla menys l'atacant. Inclós els aliats. Ex: Surf.
	const SELECCIONAR = 10 #El jugador selecciona individualment un pokemon, com qualsevol atac normal. Ex: Placaje
	const ENEMIES = 11 #L'atac afecta a tots els pokemons rivals. Ex: Malicioso
	const ALL_FIELD = 12 # Afecta al FIELD. Afecta al camp de batalla, per tant a tots els pokemons en combat, inclós l'atacant. Exemple: Tormenta Arena, Danza lluvia..
	const PLAYERS = 13 # Al revés que ENEMIES, afecta directament al pokemon atacant i aliats, pero no als enemics. Ex: Campana Cura
	const ALL_POKEMON = 14 # Afecta directament a tots els pokemons en combat. Ex: Canto Mortal
	
#class MOVE_EFFECTS:
	
class TYPES:
	const NONE = 0
	const NORMAL = 1
	const LUCHA = 2
	const VOLADOR = 3
	const VENENO = 4
	const TIERRA = 5
	const ROCA = 6
	const BICHO = 7
	const FANTASMA = 8
	const ACERO = 9
	const FUEGO = 10
	const AGUA = 11
	const PLANTA = 12
	const ELECTRICO = 13
	const PSIQUICO = 14
	const HIELO = 15
	const DRAGON = 16
	const SINIESTRO = 17
	const HADA = 18
	
class MOVE_EFFECTS:
	const IMAGEN = 10
	const IMPRESIONAR = 11
	const VELO_AURORA = 12
	const GOLPE_CUERPO = 13
	const CARGA_DRAGON = 14
	const TERREMOTO = 15
	const PARANORMAL = 16
	const PLANCHA_VOLADORA = 17
	const GOLPE_CALOR = 18
	const CUERPO_PESADO = 19
	const PANTALLA_LUZ = 20
	const MAGNITUD = 21
	const BRAZO_PINCHO = 22
	const GOLPE_FANTASMA = 23
	const REFLEJO = 24
	const GOLPE_UMBRIO = 25
	const PISOTON = 26
	const SURF = 27
	const TORBELLINO = 28
	const Z_MOVES = 999
	
	const REDUCCION = 29
	const ALLANAMIENTO = 30
	const BUCEO = 31
	const EXCAVAR = 32

class ABILITIES:

	const HEDOR = 1
	const LLOVIZNA = 2
	const IMPULSO = 3
	const ARMADURA_BATALLA = 4
	const ROBUSTEZ = 5
	const HUMEDAD = 6
	const FLEXIBILIDAD = 7
	const VELO_ARENA = 8
	const ELEC_ESTATICA = 9
	const ABSORBE_ELEC = 10
	const ABSORBE_AGUA = 11
	const DESPISTE = 12
	const ACLIMATACION = 13
	const OJO_COMPUESTO = 14
	const INSOMNIO = 15
	const CAMBIO_COLOR = 16
	const INMUNIDAD = 17
	const ABSORBE_FUEGO = 18
	const POLVO_ESCUDO = 19
	const RITMO_PROPIO = 20
	const VENTOSAS = 21
	const INTIMIDACION = 22
	const SOMBRA_TRAMPA = 23
	const PIEL_TOSCA = 24
	const SUPERGUARDA = 25
	const LEVITACION = 26
	const EFECTO_ESPORA = 27
	const SINCRONIA = 28
	const CUERPO_PURO = 29
	const CURA_NATURAL = 30
	const PARARRAYOS = 31
	const DICHA = 32
	const NADO_RAPIDO = 33
	const CLOROFILA = 34
	const ILUMINACION = 35
	const RASTRO = 36
	const POTENCIA = 37
	const PUNTO_TOXICO = 38
	const FOCO_INTERNO = 39
	const ESCUDO_MAGMA = 40
	const VELO_AGUA = 41
	const IMAN = 42
	const INSONORIZAR = 43
	const CURA_LLUVIA = 44
	const CHORRO_ARENA = 45
	const PRESION = 46
	const SEBO = 47
	const MADRUGAR = 48
	const CUERPO_LLAMA = 49
	const FUGA = 50
	const VISTA_LINCE = 51
	const CORTE_FUERTE = 52
	const RECOGIDA = 53
	const AUSENTE = 54
	const ENTUSIASMO = 55
	const GRAN_ENCANTO = 56
	const MAS = 57
	const MENOS = 58
	const PREDICCION = 59
	const VISCOSIDAD = 60
	const MUDAR = 61
	const AGALLAS = 62
	const ESCAMA_ESPECIAL = 63
	const LODO_LIQUIDO = 64
	const ESPESURA = 65
	const MAR_LLAMAS = 66
	const TORRENTE = 67
	const ENJAMBRE = 68
	const CABEZA_ROCA = 69
	const SEQUIA = 70
	const TRAMPA_ARENA = 71
	const ESPIRITU_VITAL = 72
	const HUMO_BLANCO = 73
	const ENERGIA_PURA = 74
	const CAPARAZON = 75
	const BUCLE_AIRE = 76
	const TUMBOS = 77
	const ELECTROMOTOR = 78
	const RIVALIDAD = 79
	const IMPASIBLE = 80
	const MANTO_NIVEO = 81
	const GULA = 82
	const IRASCIBLE = 83
	const LIVIANO = 84
	const IGNIFUGO = 85
	const SIMPLE = 86
	const PIEL_SECA = 87
	const DESCARGA = 88
	const PUNO_FERREO = 89
	const ANTIDOTO = 90
	const ADAPTABLE = 91
	const ENCADENADO = 92
	const HIDRATACION = 93
	const PODER_SOLAR = 94
	const PIES_RAPIDOS = 95
	const NORMALIDAD = 96
	const FRANCOTIRADOR = 97
	const MURO_MAGICO = 98
	const INDEFENSO = 99
	const REZAGADO = 100
	const EXPERTO = 101
	const DEFENSA_HOJA = 102
	const ZOQUETE = 103
	const ROMPEMOLDES = 104
	const AFORTUNADO = 105
	const RESQUICIO = 106
	const ANTICIPACION = 107
	const ALERTA = 108
	const IGNORANTE = 109
	const CROMOLENTE = 110
	const FILTRO = 111
	const INICIO_LENTO = 112
	const INTREPIDO = 113
	const COLECTOR = 114
	const GELIDO = 115
	const ROCA_SOLIDA = 116
	const NEVADA = 117
	const RECOGEMIEL = 118
	const CACHEO = 119
	const AUDAZ = 120
	const MULTITIPO = 121
	const DON_FLORAL = 122
	const MAL_SUENO = 123
	const HURTO = 124
	const POTENCIA_BRUTA = 125
	const RESPONDON = 126
	const NERVIOSISMO = 127
	const COMPETITIVO = 128
	const FLAQUEZA = 129
	const CUERPO_MALDITO = 130
	const ALMA_CURA = 131
	const COMPIESCOLTA = 132
	const ARMADURA_FRAGIL = 133
	const METAL_PESADO = 134
	const METAL_LIVIANO = 135
	const COMPENSACION = 136
	const IMPETU_TOXICO = 137
	const IMPETU_ARDIENTE = 138
	const COSECHA = 139
	const TELEPATIA = 140
	const VELETA = 141
	const FUNDA = 142
	const TOQUE_TOXICO = 143
	const REGENERACION = 144
	const SACAPECHO = 145
	const IMPETU_ARENA = 146
	const PIEL_MILAGRO = 147
	const CALCULO_FINAL = 148
	const ILUSION = 149
	const IMPOSTOR = 150
	const ALLANAMIENTO = 151
	const MOMIA = 152
	const AUTOESTIMA = 153
	const JUSTICIERO = 154
	const COBARDIA = 155
	const ESPEJO_MAGICO = 156
	const HERBIVORO = 157
	const BROMISTA = 158
	const PODER_ARENA = 159
	const PUNTA_ACERO = 160
	const MODO_DARUMA = 161
	const TINOVICTORIA = 162
	const TURBOLLAMA = 163
	const TERRAVOLTAJE = 164
	const VELO_AROMA = 165
	const VELO_FLOR = 166
	const CARRILLO = 167
	const MUTATIPO = 168
	const PELAJE_RECIO = 169
	const PRESTIDIGITADOR = 170
	const ANTIBALAS = 171
	const TENACIDAD = 172
	const MANDIBULA_FUERTE = 173
	const PIEL_HELADA = 174
	const VELO_DULCE = 175
	const CAMBIO_TACTICO = 176
	const ALAS_VENDAVAL = 177
	const MEGADISPARADOR = 178
	const MANTO_FRONDOSO = 179
	const SIMBIOSIS = 180
	const GARRA_DURA = 181
	const PIEL_FEERICA = 182
	const BABA = 183
	const PIEL_CELESTE = 184
	const AMOR_FILIAL = 185
	const AURA_OSCURA = 186
	const AURA_FEERICA = 187
	const ROMPEAURA = 188
	const MAR_DEL_ALBOR = 189
	const TIERRA_DEL_OCASO = 190
	const RAFAGA_DELTA = 191
	const FIRMEZA = 192
	const HUIDA = 193
	const RETIRADA = 194
	const HIDRORREFUERZO = 195
	const ENSANAMIENTO = 196
	const ESCUDO_LIMITADO = 197
	const VIGILANTE = 198
	const POMPA = 199
	const ACERO_TEMPLADO = 200
	const COLERA = 201
	const QUITANIEVES = 202
	const REMOTO = 203
	const VOZ_FLUIDA = 204
	const PRIMER_AUXILIO = 205
	const PIEL_ELECTRICA = 206
	const COLA_SURF = 207
	const BANCO = 208
	const DISFRAZ = 209
	const FUERTE_AFECTO = 210
	const AGRUPAMIENTO = 211
	const CORROSION = 212
	const LETARGO_PERENNE = 213
	const REGIA_PRESENCIA = 214
	const REVES = 215
	const PAREJA_DE_BAILE = 216
	const BATERIA = 217
	const PELUCHE = 218
	const CUERPO_VIVIDO = 219
	const CORANIMA = 220
	const RIZOS_REBELDES = 221
	const RECEPTOR = 222
	const REACCION_QUIMICA = 223
	const ULTRAIMPULSO = 224
	const SISTEMA_ALFA = 225
	const ELECTROGENESIS = 226
	const PSICOGENESIS = 227
	const NEBULOGENESIS = 228
	const HERBOGENESIS = 229
	const GUARDIA_METALICA = 230
	const GUARDIA_ESPECTRO = 231
	const ARMADURA_PRISMA = 232

class MOVES:
	const CORTE = 15
	const SURF = 57
	const FUERZA = 70

class MEDALS:
	const ROCA = "Roca"
	const CASCADA = "Cascada"
	const TRUENO = "Trueno"
	const ARCOIRIS = "Arcoíris"
	const ALMA = "Alma"
	const PANTANO = "Pantano"
	const VOLCAN = "Volcán"
	const TIERRA = "Tierra"

func ready():
	# Initialization here
	pass


