extends Node
class_name Trainer

export(String)var Name
export(Texture)var battle_front_sprite
export(Texture)var battle_back_sprite = null
export(String,MULTILINE)var before_battle_message
export(String,MULTILINE)var init_battle_message
export(String,MULTILINE)var end_battle_message
export(bool)var is_defeated = false
export(bool)var double_battle = false
export(bool)var is_playable = false
export(NodePath)var partner = null #Aqui hi lligarem l'NPC que fagi de parella a lhora del combat. A PARTIR DE L NPC AGAFAREM EL NODO TRAINER I ELS PKMN
var party = []
var tilesVisibility

func _ready():
	for p in get_children():
		party.push_back(DB.pokemons[p.pkm_id].make_wild(p.level))
	#pass

func is_type(type): return type == "Trainer" or .is_type(type)
func    get_type(): return "Trainer"

func has_pokemon(pk):
	for p in party:
		if p == pk:
			return true
	return false
	

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
