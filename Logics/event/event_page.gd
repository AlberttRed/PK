
extends Node

export(String) var condition1 
export(String) var condition2
export(String) var condition3
var running = false
var running_choice = false
var cmd_move_on = false
var parentEvent = null


func _ready():
	add_to_group("PAGE")
	
func _init():
	add_user_signal("finished_page")
	add_user_signal("executed")
func run():
	exec_commands(get_children())
	#call_deferred("exec_commands", get_children())
	while running:
		yield(get_tree(), "idle_frame")	
	#yield(self,"executed")
	print("page tregfgd finished")
	emit_signal("finished_page")

func exec_commands(commands):
	running = true
	for cmd in commands:
		print(cmd.get_name())
		if (cmd.get_name().begins_with("cmd_change_page")):
			get_parent().get_parent().set_page(get_parent().get_child(cmd.page))
		elif (cmd.get_name().begins_with("cmd_move")):
			if cmd.nodePath.is_empty():#get_parent().get_parent().eventTarget == ProjectSettings.get("Player"):
				ProjectSettings.get("Player").active_events.push_back(parentEvent)
				ProjectSettings.get("Player").being_controlled = true
				print("HE..RE")
				cmd.run()
				yield(cmd, "finished")
				print("FINISH")
				#ProjectSettings.get("Player").active_events.erase(get_parent().get_parent())
			else:
				cmd.call_deferred("run")
				print("FINISH")
		elif (cmd.get_name().begins_with("cmd_msg")):
			cmd.run()
			yield(cmd, "finished")
			if cmd.choices != null and cmd.choices.size() != 0:# or (cmd.choices[0] != null and cmd.choices[0].size() != 0):
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
	#emit_signal("executed")

func is_executing():
	for c in get_children():
		if c.executing:
			return true
	return false