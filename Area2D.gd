extends Area2D

var parent_map
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
#var world = ProjectSettings.get("Global_World")
var thread = Thread.new()
var original_name = get_name()
var parentMap

var mapTarget
var posTarget

func _ready():
	#parent_map = get_parent()
	connect("area_entered",self,"_execPlayerTouch")
	GAME_DATA.WORLD.connect("do_load", self, "load_map")
	set_process(false)
	#ProjectSettings.get("Player").update_maparea_exception(self)
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
#func _process(delta):
#	if get_groups().has(mapTarget.get_name()):
#		#3print("reparent " + get_parent().get_name())
#		parent_map = get_parent()
#		var scene_name = name
#		#print(scene_name)
#		#print(GAME_DATA.WORLD.CAPA_TERRA.get_node("CapaTerra_").get_position())
#		#print(get_position())
#	#	if pos == null:
#	#		pos = Vector2(0, 0)
#		get_parent().remove_child(self)
##		GAME_DATA.WORLD.get_node("CanvasModulate/" + scene_name).add_child(self, true)
##		set_owner(GAME_DATA.WORLD.get_node("CanvasModulate/" + scene_name))
#		GAME_DATA.WORLD.MAP_AREA.add_child(self, true)
#		set_owner(GAME_DATA.WORLD.MAP_AREA)
#		set_position(get_position() + posTarget)#
#	set_process(false)
	
func _execPlayerTouch(target):
	if (target.get_name() == "Player" or target.get_parent().get_name() == "Player"):# and !is_in_group("NPC") and !is_in_group("Evento"):
		
		#print("map_entered")
		#print(parentMap.get_name())
		if parentMap != GAME_DATA.ACTUAL_MAP:# and !parentMap.loaded:
			print("Actual map: " + str(parentMap.get_name()))
			if GAME_DATA.ACTUAL_MAP != null:#ProjectSettings.set("Previous_Map", ProjectSettings.get("Actual_Map"))
				GAME_DATA.PREVIOUS_MAP = GAME_DATA.ACTUAL_MAP
				GAME_DATA.PREVIOUS_MAP.is_connection = true
			GAME_DATA.ACTUAL_MAP = parentMap
			#GAME_DATA.ACTUAL_MAP.call_deferred("set_connections")
		GAME_DATA.WORLD.loading = false
		#parentMap.loaded = true
		#if GAME_DATA.ACTUAL_MAP != null:
			#print("Player touch Map: " + parent_map.get_name())
		#print("Parent map: " + parent_map.get_name())
		#world.get_thread().start(GAME_DATA.ACTUAL_MAP, "set_connections")
		#GLOBAL.set_connections(GAME_DATA.ACTUAL_MAP)
		#if !GAME_DATA.WORLD.loading or GAME_DATA.WORLD.actual_scene.get_name() == GAME_DATA.ACTUAL_MAP.get_name():
			#yield(GAME_DATA.ACTUAL_MAP,"connected")
	#		if ProjectSettings.get("Global_World").get_node("AudioStreamPlayer2D").get_stream() != null and ProjectSettings.get("Global_World").get_node("AudioStreamPlayer2D").get_stream() != parent_map.music:
	#			ProjectSettings.get("Global_World").get_node("AudioStreamPlayer2D").stop_music(1.5)
	#			yield(ProjectSettings.get("Global_World").get_node("AudioStreamPlayer2D"), "stopped")
	#			ProjectSettings.get("Global_World").get_node("AudioStreamPlayer2D").play_music(parent_map.music)
	

func set_disable(state):
	$CollisionShape2D.disabled = state

func initialize(position):
	print("AAAAAAAAAAAAAA")
	set_position(get_position() + position)
	
func reparent(pos):
	#3print("reparent " + get_parent().get_name())
	parent_map = get_parent()
	var scene_name = get_name()
	#print(scene_name)
	#print(GAME_DATA.WORLD.CAPA_TERRA.get_node("CapaTerra_").get_position())
	#print(get_position())
	if pos == null:
		pos = Vector2(0, 0)
	get_parent().remove_child(self)
	GAME_DATA.WORLD.get_node("CanvasModulate/" + scene_name).add_child(self)
	set_owner(GAME_DATA.WORLD.get_node("CanvasModulate/" + scene_name))
	#print(get_position())
	set_position(get_position() + pos)#get_position() + pos)
	#print(get_position())
	#print(get_position())
	
func load_map(pos, map):
	posTarget = pos
	mapTarget = map
	#set_process(true)
	if get_groups().has(map.get_name()):
		#3print("reparent " + get_parent().get_name())
		parent_map = get_parent()
		var scene_name = name
		#print(scene_name)
		#print(GAME_DATA.WORLD.CAPA_TERRA.get_node("CapaTerra_").get_position())
		#print(get_position())
	#	if pos == null:
	#		pos = Vector2(0, 0)
		get_parent().remove_child(self)
#		GAME_DATA.WORLD.get_node("CanvasModulate/" + scene_name).add_child(self, true)
#		set_owner(GAME_DATA.WORLD.get_node("CanvasModulate/" + scene_name))
		GAME_DATA.WORLD.MAP_AREA.add_child(self, true)
		set_owner(GAME_DATA.WORLD.MAP_AREA)
		set_position(get_position() + pos)#get_position() + pos)
		#print(get_position())
	#print(get_position())

func start(pos, map):
	if !thread.is_active():
		thread.start(self, "loading_thread_func", [pos, map])

func loading_thread_func(userdata):
	load_map(userdata[0], userdata[1])
	call_deferred("on_exiting_thread")

func on_exiting_thread():
	# this is executed on the main thread
	thread.wait_to_finish()
	#emit_signal("background_loading_complete")
