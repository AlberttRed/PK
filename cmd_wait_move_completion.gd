extends Node
var parentEvent = null
var parentPage = null

func _init():
	add_user_signal("finished")

func _ready():
	add_to_group("CMD")


func run():
	print("wait move copletation started")
	#ProjectSettings.get("Player").can_interact = false
	while get_parent().cmd_move_on:
		print("po")
		yield(get_tree(), "idle_frame")
	print("wait move copletation finished")
	parentPage.finished_command()
	emit_signal("finished")
