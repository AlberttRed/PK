extends Node

export(bool) var Transparent
export(NodePath) onready var nodePath
var Target
var i = 0
var count = false

func _init():
	add_user_signal("finished")

func _ready():
	pass
	
func _process(delta):
	if count:
		i += 1

func run():
	print("set transparent to " + str(Transparent) + " started")
	if nodePath == null:
		print("TARGET TANSPARENT: Player")
		Target = ProjectSettings.get("Player")
	else:
		print("TARGET TANSPARENT: " + nodePath)
		Target = get_node(nodePath)
	Target.get_node("Sprite").visible = !Transparent
	#Target.Transparent = Transparent
	while i < 1:
		count = true
		yield(get_tree(), "idle_frame")
	count = false
	print("set transparent to " + str(Transparent) + " finished")
	emit_signal("finished")