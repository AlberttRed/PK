extends Area2D

var parent_map
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var world = ProjectSettings.get("Global_World")
var thread

func _ready():
	#parent_map = get_parent()
	connect("area_entered",self,"_execPlayerTouch")
	#ProjectSettings.get("Player").update_maparea_exception(self)
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _execPlayerTouch(target):
	
	if (target.get_name() == "Player" or target.get_parent().get_name() == "Player"):# and !is_in_group("NPC") and !is_in_group("Evento"):
		
		print("map_entered")
		print(parent_map.get_name())
		GAME_DATA.ACTUAL_MAP = parent_map
		
		#if GAME_DATA.ACTUAL_MAP != null:
			#print("Player touch Map: " + parent_map.get_name())
		#print("Parent map: " + parent_map.get_name())
		#world.get_thread().start(GAME_DATA.ACTUAL_MAP, "set_connections")
		#GLOBAL.set_connections(GAME_DATA.ACTUAL_MAP)
		GAME_DATA.ACTUAL_MAP.call_deferred("set_connections")
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
	print("reparent " + get_parent().get_name())
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
