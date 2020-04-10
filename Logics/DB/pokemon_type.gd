
extends Node

export(String) var internal_name = ""
export(String) var Name = ""
export(int) var id = 0
export(Array) var ineffective = Array() # the types this type is ineffective against.
export(Array) var no_effect_to = Array() # the types this type has no effect against.
export(Array) var no_effect_from = Array() # the types this type has no effect from.
export(Array) var resistance = Array() # the types this type is resistant to.
export(Array) var super_effective = Array() # the types this type is super effective against.
export(Array) var weakness = Array() # the types this type is weak to.
export(int) var panelMove_y = 0 #la posició del panel en la imatge
export(Texture)var typeImage = null

func get_typeImage():
	return get_node("TypeImage").frame
	
func get_effectiveness_from(type):
	if no_effect_from.has(type):
		return 0
	elif resistance.has(type):
		return 0.5
	elif weakness.has(type):
		return 2
	else:
		return 1
		
func get_effectiveness_against(type):
	if no_effect_to.has(type):
		return 0
	elif ineffective.has(type):
		return 0.5
	elif super_effective.has(type):
		return 2
	else:
		return 1
