extends Node

var functions = {"Move_Function001":Move_Function001, "Move_Function002":Move_Function002, "Move_Function003":Move_Function003} # create an empty Dictionary

#	functions["Move_Function001"] = Move_Function001.new() #store initial int value
#	functions["Move_Function002"] = Move_Function002.new()
#	print("FUNCTIONS")

class Move_Function001:# extends "res://Logics/game_data/move_instance.gd":#"res://Logics/DB/pokemon_move.gd":
	func ApplyDamage(move, from, to):
		var damage
		move = DB.moves[move.id]
		if move.is_special():
			print("es especial!")
		else:
			print("no es especial :(")
#
#	func ShowAnimation():
#		ProjectSettings.get("Battle_AnimationPlayer").play("Stat_Up")
#
class Move_Function002:# extends "res://Logics/game_data/move_instance.gd":#"res://Logics/DB/pokemon_move.gd":
	func ApplyDamage(move):
		if DB.moves[move.id].is_special():
			print("es especial!")
		else:
			print("no es especial :(")
	
#	func ShowAnimation():
#		ProjectSettings.get("Battle_AnimationPlayer").play("Stat_Down")
#
class Move_Function003:# extends "res://Logics/game_data/move_instance.gd":#"res://Logics/DB/pokemon_move.gd":
	func ApplyDamage(move):
		if DB.moves[move.id].is_special():
			print("es especial!")
		else:
			print("no es especial :(")
	
#	func ShowAnimation():
#		ProjectSettings.get("Battle_AnimationPlayer").play("Heal")