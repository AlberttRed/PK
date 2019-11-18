extends Node2D

#export(String, FILE, "*.tres") var animation
export(int) var speed = 1
var parentEvent = null
var parentPage = null

func _init():
	add_user_signal("finished")
	
func _ready():
	pass

func run():
	print("Cut started")
	var animationPlayer = GLOBAL.running_events.back().get_node("AnimationPlayer")
	GUI.show_msg("aasda asda asdad adsad asdasd asdasd asasd asda dasdasd sa.")#GUI.show_msg("Parece que este arbol se puede cortar.")
	while (GUI.is_visible()):
		yield(get_tree(),"idle_frame")	
	if GLOBAL.CanDoCut():
		GUI.show_msg("Quieres usar Corte?", null, null, "", [["SÍ","NO"],true,"Choice2"])
		while (GUI.is_visible()):
			yield(get_tree(),"idle_frame")
		if GLOBAL.get_choice_selected() == "Choice1":
			print("A cortar!")
			#can_interact = false
			animationPlayer.play("cut")
			while (animationPlayer.is_playing()):
				yield(get_tree(),"idle_frame")
			GLOBAL.running_events.back().deleteAtEnd = true
			#can_interact = true
	print("Cut finished")
	emit_signal("finished")