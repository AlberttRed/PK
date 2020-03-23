extends Area2D

var parent_map
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

	
func _ready():
	connect("area_entered",self,"_execPlayerTouch")
	#ProjectSettings.get("Player").update_maparea_exception(self)
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _execPlayerTouch(target):
	
	if (target.is_in_group("Player") or target.get_parent().is_in_group("Player")) and !is_in_group("NPC") and !is_in_group("Evento"):

		print("map_entered")
		GAME_DATA.ACTUAL_MAP = parent_map
		print("Player touch Map: " + parent_map.get_name())
		print("Parent map: " + parent_map.get_name())
		GAME_DATA.ACTUAL_MAP.call_deferred("set_connections")
		#yield(GAME_DATA.ACTUAL_MAP,"connected")
		if ProjectSettings.get("Global_World").get_node("AudioStreamPlayer2D").get_stream() != null and ProjectSettings.get("Global_World").get_node("AudioStreamPlayer2D").get_stream() != parent_map.music:
			ProjectSettings.get("Global_World").get_node("AudioStreamPlayer2D").stop_music(1.5)
			yield(ProjectSettings.get("Global_World").get_node("AudioStreamPlayer2D"), "stopped")
			ProjectSettings.get("Global_World").get_node("AudioStreamPlayer2D").play_music(parent_map.music)




