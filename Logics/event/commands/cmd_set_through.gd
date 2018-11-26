extends Node
#export(String, FILE, "*.tres") var animation
export(bool) var Through = false
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
	ProjectSettings.get("Player").can_interact = false
	print("set through started")
	if nodePath == null:
		Target = ProjectSettings.get("Player")
	else:
		print(nodePath)
		Target = get_node(nodePath)
	Target.Through = Through
	while i < 1:
		count = true
		yield(get_tree(), "idle_frame")
	count = false
	print("set through finished")
	emit_signal("finished")