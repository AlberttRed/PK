extends Node

class_name Item

export(int) var id = 0
export(String) var internal_name = ""
export(String) var Name = ""

export(String) var description = ""
export(int) var cost = 0

## ATRIBUTOS

export(bool) var countable = false
export(bool) var consumible = false
export(bool) var overworld = false
export(bool) var battle = false
export(bool) var holdable = false
export(bool) var holdable_passive = false
export(bool) var holdable_active = false
export(bool) var underground = false

export(int) var category = 0  ## La id de la categoria, s'hauràn de crear les constants a CONST.gd
