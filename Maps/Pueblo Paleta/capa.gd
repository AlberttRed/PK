extends TileMap


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
func initialize(position):
	print("AAAAAAAAAAAAAA")
	set_position(get_position() + position)
	
#func _process(delta):
#	print("capa " + mapTarget.get_name())
#	if get_groups().has(mapTarget.get_name()):
#		print("capa " + mapTarget.get_name())
#		var scene_name = name
#		get_parent().remove_child(self)
#		GAME_DATA.WORLD.get_node("CanvasModulate/" + scene_name).add_child(self, true)
#		set_owner(GAME_DATA.WORLD.get_node("CanvasModulate/" + scene_name))
#		#print(get_position())
#		#if scene_name != "CapaTerra_" and scene_name != "CapaTerra2_" and scene_name != "CapaTerra3_" and scene_name != "CapaAlta_":
#		#print(map.get_name())
#		set_position(get_position() + posTarget)#get_position() + pos)
#		yield(get_tree(),"idle_frame")
#		print("STOPPPP")
#	set_process(false)
func reparent(pos):
	var scene_name = get_name()
	#print(scene_name)
	get_parent().remove_child(self)
	GAME_DATA.WORLD.get_node("CanvasModulate/" + scene_name).add_child(self)
	set_owner(GAME_DATA.WORLD.get_node("CanvasModulate/" + scene_name))
	#print(get_position())
	#if scene_name != "CapaTerra_" and scene_name != "CapaTerra2_" and scene_name != "CapaTerra3_" and scene_name != "CapaAlta_":
	set_position(get_position() + pos)#get_position() + pos)
	#print(get_position())
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func start(pos, map):
	if !thread.is_active():
		thread.start(self, "loading_thread_func", [pos, map])


func load_map(pos, map):
	#if map.name != "Ciudad_Verde":
	posTarget = pos
	mapTarget = map
	#set_process(true)
	if get_groups().has(map.get_name()):
		var scene_name = name
		get_parent().remove_child(self)
		GAME_DATA.WORLD.get_node("CanvasModulate/" + scene_name).add_child(self, true)
		set_owner(GAME_DATA.WORLD.get_node("CanvasModulate/" + scene_name))
		#print(get_position())
		#if scene_name != "CapaTerra_" and scene_name != "CapaTerra2_" and scene_name != "CapaTerra3_" and scene_name != "CapaAlta_":
		#print(map.get_name())
		set_position(get_position() + pos)#get_position() + pos)

func loading_thread_func(userdata):
	load_map(userdata[0], userdata[1])
	call_deferred("on_exiting_thread")

func on_exiting_thread():
	# this is executed on the main thread
	thread.wait_to_finish()
	#emit_signal("background_loading_complete")
