extends Node
#export(String, FILE, "*.tres") var animation
export(bool) var Through = false
export(NodePath) onready var nodePath
var Target
var i = 0
var count = false
var executing = false
var parentEvent = null
var parentPage = null

func _init():
	add_user_signal("finished")
	
func _ready():
	add_to_group("CMD")

func _process(delta):
	print("process1 " + self.get_name())
	if count:
		i += 1

func run():
	executing = true
	print("set through to " + str(Through) + " started")
	if nodePath.is_empty():
		#print("TARGET THROUGH: Player")
		#Target = ProjectSettings.get("Player")
		Target = GAME_DATA.PLAYER
	else:
		#print("TARGET THROUGH: " + nodePath)
		Target = get_node(nodePath)
	Target.Through = Through
	if Target != GAME_DATA.PLAYER:#ProjectSettings.get("Player"):
		Target.add_to_group("Pasable")
	while i < 1:
		count = true
		yield(get_tree(), "idle_frame")
	count = false
	i = 0
	print("set through to " + str(Through) + " finished")
	executing = false
	parentEvent.finished_command()
	emit_signal("finished")
