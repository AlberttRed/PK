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
	print("set through to " + str(Through) + " started")
	if nodePath == null:
		print("TARGET THROUGH: Player")
		Target = ProjectSettings.get("Player")
	else:
		print("TARGET THROUGH: " + nodePath)
		Target = get_node(nodePath)
	Target.Through = Through
	if Target != ProjectSettings.get("Player"):
		GLOBAL.running_events.back().makePasable()
	while i < 1:
		count = true
		yield(get_tree(), "idle_frame")
	count = false
	i = 0
	print("set through to " + str(Through) + " finished")
	emit_signal("finished")