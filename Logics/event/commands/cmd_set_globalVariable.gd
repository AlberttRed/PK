extends Node
#export(String, FILE, "*.tres") var animation
export(bool) var state = false
export(String) var Gvariable_name
var parentEvent = null
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
	#ProjectSettings.get("Player").can_interact = false
	print("set Gvariable started")
	if Gvariable_name != null:
		GLOBAL.get_node(Gvariable_name).state = state
	while i < 1:
		count = true
		yield(get_tree(), "idle_frame")
	count = false
	print("set Gvariable finished")
	emit_signal("finished")