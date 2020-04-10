extends YSort


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var original_name = get_name()
var thread = Thread.new()

var mapTarget
var posTarget

# Called when the node enters the scene tree for the first time.
func _ready():
	GAME_DATA.WORLD.connect("do_load", self, "load_map")
	set_process(false)

#func _process(delta):
#	if get_groups().has(mapTarget.get_name()):
#		var scene_name = name
#		get_parent().remove_child(self)
#		GAME_DATA.WORLD.EVENTOS.add_child(self, true)
#		set_owner(GAME_DATA.WORLD.EVENTOS)
#	set_process(false)
	
func initialize(position):
	#connect("do_load",GAME_DATA.WORLD,"load_map")
	set_position(get_position() + position)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func reparent(data):
	var scene_name = get_name()
	#print(scene_name)
	get_parent().remove_child(self)
	GAME_DATA.WORLD.get_node("CanvasModulate/" + scene_name).add_child(self)
	set_owner(GAME_DATA.WORLD.get_node("CanvasModulate/" + scene_name))

func start(pos, map):
	if !thread.is_active():
		thread.start(self, "loading_thread_func", [pos, map])

func load_map(pos, map):
	mapTarget = map
	posTarget = pos
	set_process(true)
	if get_groups().has(map.get_name()):
			var scene_name = name
			get_parent().remove_child(self)
			GAME_DATA.WORLD.EVENTOS.add_child(self, true)
			set_owner(GAME_DATA.WORLD.EVENTOS)

func loading_thread_func(userdata):
	load_map(userdata[0], userdata[1])
	call_deferred("on_exiting_thread")

func on_exiting_thread():
	# this is executed on the main thread
	thread.wait_to_finish()
	#emit_signal("background_loading_complete")
