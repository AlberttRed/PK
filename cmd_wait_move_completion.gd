extends Node
var parentEvent = null

func _init():
	add_user_signal("finished")

func _ready():
	add_to_group("CMD")


func run():
	print("wait_move_copletation started")
	ProjectSettings.get("Player").can_interact = false
	while get_parent().cmd_move_on:
		print("po")
		yield(get_tree(), "idle_frame")
	ProjectSettings.get("Player").can_interact = true
	print("wait_move_copletation finished")
	emit_signal("finished")