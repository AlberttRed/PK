extends Node
#export(String, FILE, "*.tres") var animation
export(AudioStream) onready var sound
export(bool) var wait = false
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
	if count:
		i += 1

func run():
	executing = true
	print("playing sound started")
	parentEvent.get_node("AudioSystem").play_sound(sound)
	if wait:
		yield(parentEvent, "played")
	else:
		while i < 1:
			count = true
			yield(get_tree(), "idle_frame")
	count = false
	i = 0
	print("playing sound finished")
	executing = false
	emit_signal("finished")