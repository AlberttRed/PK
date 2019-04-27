extends Node

var id
var pp = 5
var max_pp = 5
var mod_pp = 0

func get_name():
	return DB.moves[id].Name
func get_power():
	return DB.moves[id].power
func get_acuracy():
	return DB.moves[id].acuracy
func get_move_type():
	return DB.types[DB.moves[id].type]
func get_type_name():
	return DB.types[DB.moves[id].type].Name
	
func get_priority():
	return DB.moves[id].priority
	
func doMove(from,to):
	DB.moves[id].ShowAnimation(from,to)
	yield(DB.moves[id], "animation_done")
	DB.moves[id].doMove(self,from,to)
	yield(DB.moves[id], "move_done")
	
func ShowAnimation(from,to):
	DB.moves[id].ShowAnimation(from,to)
	yield(DB.moves[id], "animation_done")

func is_type(type): return type == "Move" or .is_type(type)
func    get_type(): return "Move"