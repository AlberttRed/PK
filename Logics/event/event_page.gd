
extends Node

export(String) var condition1 
export(String) var condition2
export(String) var condition3

var cmd_move_on = false


func _init():
	add_user_signal("finished")

func run():
	for cmd in get_children():
		if (cmd.get_name().begins_with("cmd_change_page")):
			get_parent().get_parent().set_page(get_parent().get_child(cmd.page))
		elif (cmd.get_name().begins_with("cmd_move")):
			cmd.run()
		else:
			cmd.run()
			yield(cmd, "finished")

	emit_signal("finished")

