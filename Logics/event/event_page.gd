
extends Node

export(String) var condition1 
export(String) var condition2
export(String) var condition3
var running = false
var running_choice = false
var cmd_move_on = false


func _init():
	add_user_signal("finished")
	add_user_signal("executed")
func run():
	exec_commands(get_children())
	while running:
		yield(get_tree(), "idle_frame")	#yield(self,"executed")
	print("page event finished000")
	emit_signal("finished")

func exec_commands(commands):
	running = true
	for cmd in commands:
		print(cmd.get_name())
		if (cmd.get_name().begins_with("cmd_change_page")):
			get_parent().get_parent().set_page(get_parent().get_child(cmd.page))
		elif (cmd.get_name().begins_with("cmd_move")):
			cmd.run()
		elif (cmd.get_name().begins_with("cmd_msg")):
			cmd.run()
			yield(cmd, "finished")
			if cmd.choices != null:
				running_choice = true
				print("exec commands from " + GLOBAL.get_choice_selected())
				exec_commands(cmd.get_node(GLOBAL.get_choice_selected()).get_children())
				while running_choice:
					yield(get_tree(), "idle_frame")
				print("SACABO")
			print("ups")
		else:
			cmd.run()
			yield(cmd, "finished")
			print("cmd finished")
	if !running_choice:
		running = false
	running_choice = false
		