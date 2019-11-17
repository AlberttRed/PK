extends "res://Logics/event/Event.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _physics_process(delta):# and !$MoveTween.is_active():
	if being_controlled:
		for dir in moves.keys():
			if Input.is_action_pressed("ui_" + dir + "_event"):
				can_move = false
				move(dir)
