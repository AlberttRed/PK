
extends Node

export(String, MULTILINE) var text = ""
export(Array, String) var choices = null
export(bool) var can_cancel = false
export(String) var default_at_cancel = ""
var running = false
var parentEvent = null

func _ready():
	add_to_group("CMD")
	
func _init():
	add_user_signal("finished")

func run():
	running = true
	GUI.show_msg(text, null, null, "", [choices,can_cancel,default_at_cancel])
	while (GUI.is_visible()):
		yield(get_tree(),"idle_frame")
	running = false
	emit_signal("finished")
	


