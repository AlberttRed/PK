
extends Node

export(String, MULTILINE) var text = ""
export(Array, String) var choices = null
export(bool) var can_cancel = false
export(String) var default_at_cancel = ""
var running = false
var parentEvent = null
var executing = false

func _ready():
	add_to_group("CMD")
	
func _init():
	add_user_signal("finished")

func run():
	running = true
	executing = true
	GUI.show_msg(text, null, null, "", [choices,can_cancel,default_at_cancel], is_continuous_message())
#	while (GUI.is_visible()):
#		yield(get_tree(),"idle_frame")
	yield(GUI, "finished")
	running = false
	executing = false
	emit_signal("finished")
	
func is_continuous_message():
	var idx = parentEvent.current_page.get_children().find(self)
	if idx != -1 and idx+1 < parentEvent.current_page.get_children().size():
		print("next cmd: " + str(parentEvent.current_page.get_child(idx+1).get_name()))
		if "cmd_msg" in parentEvent.current_page.get_child(idx+1).get_name():
			return false
	return true
		

