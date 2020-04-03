
extends Node

export(Array, String) var choices
var parentEvent = null
var parentPage = null

func _init():
	add_user_signal("finished")

func run():
	print("show choices started")
	GUI.show_choices(choices)
	while (GUI.is_visible()):
		yield(get_tree(),"idle_frame")
	print("show choices finished")
	parentEvent.finished_command()
	emit_signal("finished")
	


