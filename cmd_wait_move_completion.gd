extends Node


func _init():
	add_user_signal("finished")

func _ready():
	pass


func run():
	#ProjectSettings.get("Player").can_interact = false
	while get_parent().cmd_move_on:
		yield(get_tree(), "idle_frame")

	emit_signal("finished")