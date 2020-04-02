
extends Node

export(String, MULTILINE) var text = ""
export(Array, String) var choices = null
export(bool) var can_cancel = false
export(String) var default_at_cancel = ""
var running = false
var executing = false
var parentEvent = null
var parentPage = null


func _ready():
	add_to_group("CMD")
	
func _init():
	add_user_signal("finished")

func run():
	running = true
	executing = true
	GUI.show_msg(text, null, null, "", [choices,can_cancel,default_at_cancel], !is_continuous_message())#, is_continuous_message())
	#while (GUI.is_visible()):# and !is_continuous_message()):
		#yield(get_tree(),"idle_frame")
	yield(GUI, "input")
	running = false
	GUI.next = false
	executing = false
	parentEvent.finished_command()
	emit_signal("finished")
	
func _execPlayerTouch(target):
		if target.get_parent().get_name() == "Player":
			print("PLAYER TOUCH")
			#eventTarget = target.get_parent()
			#target.get_parent().event = self
			#if Pasable:# or player.can_interact:
			run()
	
func is_continuous_message():
	if get_child_count() > 0:
		if "cmd_msg" in get_child(0).get_name():
			return true
	return false
		

