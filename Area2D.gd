extends Area2D

var parent_map
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

	
func _ready():
	connect("area_entered",self,"_execPlayerTouch")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _execPlayerTouch(target):
	if target.is_in_group("Player"):
#		if ProjectSettings.get("Global_World").faded:
#			target.get_parent().can_interact = false
#			ProjectSettings.get("Global_World").get_node("AnimationPlayer").play("FadeIn", -1, 2)
#			while ProjectSettings.get("Global_World").get_node("AnimationPlayer").is_playing():
#				yield(get_tree(), "idle_frame")
#			ProjectSettings.get("Global_World").faded = false
#			target.get_parent().can_interact = true
		print("map_entered")
		ProjectSettings.set("Actual_Map", parent_map)
		print("Player touch Map: " + get_groups()[0])
		ProjectSettings.get("Actual_Map").init()
		ProjectSettings.get("Actual_Map").set_connections()
#
		#load("res://" + get_groups()[0].replace(" ", "_") + ".tscn").instance().init()
		#ProjectSettings.get("Actual_Map").init()
		#get_parent().init()
