extends Node2D

export(bool) var play_intro = false
export(bool) var disable_battles = false
#export(String, FILE, "*.tscn") var actual_scene
export(String) var actual_scene
export(Vector2) var initial_position
var Player = preload("res://Logics/event/Player.tscn").instance()#preload("res://Player.tscn").instance()
var thread = Thread.new()
var thread2 = Thread.new()
var loading = false
var faded = false
var loading_scene
var CAPA_TERRA
var CAPA_TERRA2
var CAPA_TERRA3
var EVENTOS
var CAPA_ALTA
var MAP_AREA
signal do_load
var loading_map = null
var offsets = []

var mapToLoad
var deletePreviousMap
var map_pos

func _ready():
	set_process(false)
	add_user_signal("do_load")
	#add_user_signal("loaded")
	print("World get ready")
	
	#add_child(load("res://Pueblo_Paleta.tscn").instance())
	loading = true
	GAME_DATA.PLAYER = Player
	
	CAPA_TERRA = $CanvasModulate/CapaTerra_
	CAPA_TERRA2 = $CanvasModulate/CapaTerra2_
	CAPA_TERRA3 = $CanvasModulate/CapaTerra3_
	EVENTOS = $CanvasModulate/Eventos_
	CAPA_ALTA = $CanvasModulate/CapaAlta_
	MAP_AREA = $CanvasModulate/MapArea_
	
	
	GAME_DATA.WORLD = self
	GAME_DATA.EVENTS_LOADED = $CanvasModulate/Eventos_
	ProjectSettings.set("Global_World", self)
	ProjectSettings.set("Eventos", get_node("CanvasModulate/Eventos_"))
	if play_intro:
		GUI.start_intro()
	else:
		GAME_DATA.new_game()
	yield(GAME_DATA, "start")
	loading = false

#	$TransitionColor.rect_global_position = Vector2(0,0)
#	$TransitionColor.rect_position = Vector2(0,0)
#	GAME_DATA.ACTUAL_MAP = load(actual_scene).instance()
#	#ProjectSettings.set("Actual_Map", load(actual_scene).instance())
#	print(GAME_DATA.ACTUAL_MAP.get_node("Area2D_").get_name())
#	#print(ProjectSettings.get("Actual_Map").get_node("Area2D_").get_name())
#	Player.set_position(initial_position)
#	GAME_DATA.ACTUAL_MAP.load_map(false)
#	#ProjectSettings.get("Actual_Map").load_map(false)
#	yield(GAME_DATA.ACTUAL_MAP, "loaded")
#	#yield(ProjectSettings.get("Actual_Map"), "loaded")
#	$AudioStreamPlayer2D.play_music(GAME_DATA.ACTUAL_MAP.music)
	#$AudioStreamPlayer2D.play_music(ProjectSettings.get("Actual_Map").music)
	#print("hala madrid: " + ProjectSettings.get("Actual_Map").area.get_name())
#	Player.set_position(Vector2(-16, -48))
	#ProjectSettings.get("Actual_Map").init()
	#get_child(0).init(Vector2(-16, -48))
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
func _process(delta):
	print("processssa")
	add_child(mapToLoad)
	mapToLoad.set_owner(self)
	mapToLoad.load_map(deletePreviousMap, mapToLoad, map_pos)
	#yield(map, "loaded")
	loading = true
	yield(get_tree(),"idle_frame")
	set_process(false)

func _exit_tree():
	if thread.is_active():
		thread.wait_to_finish()
	if thread2.is_active():
		thread2.wait_to_finish()
	
func load_map(map, deletePrevious, position = null):
	add_child(map)
	map.set_owner(self)
	mapToLoad = map
	deletePreviousMap = deletePrevious
	map_pos = position
	map.load_map(deletePrevious, map, position)
	#set_process(true)
	#yield(map, "loaded")
	loading = true
	#yield(map, "loaded")
#	if GAME_DATA.PLAYER.get_parent() != null:
#		GAME_DATA.PLAYER.get_parent().remove_child(GAME_DATA.PLAYER)
#	GAME_DATA.WORLD.EVENTOS.add_child(GAME_DATA.PLAYER)
	#remove_child(map)

func update_map_children(pos, map):
	print("do_load!")
	emit_signal("do_load", pos, map)

func load_maps():
	for w in GAME_DATA.MAPS:
		var map = GAME_DATA.MAPS[w]
		if !map.loaded:
			add_child(map)
			map.set_owner(self)
			map.load_map(false, map)
		map.set_connections()
