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
#		if ProjectSettings.get("Global_World").faded:
#			target.get_parent().can_interact = false
#			ProjectSettings.get("Global_World").get_node("AnimationPlayer").play("FadeIn", -1, 2)
#			while ProjectSettings.get("Global_World").get_node("AnimationPlayer").is_playing():
#				yield(get_tree(), "idle_frame")
#			ProjectSettings.get("Global_World").faded = false
#			target.get_parent().can_interact = true
		print("map_entered")
		ProjectSettings.set("Actual_Map", parent_map)
		print("Player touch Map: " + parent_map.get_name())
		print("Parent map: " + parent_map.get_name())
#		ProjectSettings.get("Actual_Map").init()
		ProjectSettings.get("Actual_Map").set_connections()
		if ProjectSettings.get("Global_World").get_node("AudioStreamPlayer2D").get_stream() != null and ProjectSettings.get("Global_World").get_node("AudioStreamPlayer2D").get_stream() != parent_map.music:
			ProjectSettings.get("Global_World").get_node("AudioStreamPlayer2D").stop_music(1.5)
			yield(ProjectSettings.get("Global_World").get_node("AudioStreamPlayer2D"), "stopped")
			ProjectSettings.get("Global_World").get_node("AudioStreamPlayer2D").play_music(parent_map.music)
#		target.update_maparea_exception(self)
#
#
		#load("res://" + get_groups()[0].replace(" ", "_") + ".tscn").instance().init()
		#ProjectSettings.get("Actual_Map").init()
		#get_parent().init()





