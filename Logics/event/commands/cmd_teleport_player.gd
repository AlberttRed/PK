extends Node

export(String, FILE, "*.tscn") var world_scene
export(Vector2) var Map_XY

var Player = null
var Scene = null
var wworld = null
var aScene = null
var i = 0
var count = false
var parentEvent = null
var parentPage = null

onready var animationPlayer = ProjectSettings.get("Global_World").get_node("AnimationPlayer")

func _init():
	add_user_signal("finished")

func _ready():
	Player = ProjectSettings.get("Player")
	add_to_group("CMD")
	
func _process(delta):
	if count:
		i += 1

func run():
	print("teleport event started")
	if Map_XY != null and Player != null:
#		while Player.get_moving():
#			yield(get_tree(), "idle_frame")
		if !world_scene.empty():
#			Player.get_parent().remove_child(Player)
				Scene = load(world_scene).instance()
	#			print("World: " + wworld.get_name())
				Player.set_position(Vector2(99999,99999))
				Scene.load_map(true)
#				for node in get_tree().get_nodes_in_group(ProjectSettings.get("Previous_Map").get_name()):
#					if node.get_name() != "Eventos_" and node != get_parent().get_parent().get_parent():
#						node.call_deferred("free")
#					elif node == get_parent().get_parent().get_parent():
#						node.hide()

		
				Player.set_position(Map_XY)
				
				animationPlayer.play("FadeIn", -1, 2)	
				while animationPlayer.is_playing():
					yield(get_tree(), "idle_frame")
				ProjectSettings.get("Global_World").faded = false			
				
				#get_parent().get_parent().get_parent().call_deferred("free")
		else:
			Player.set_position(Map_XY)
			while i < 1:
				count = true
				yield(get_tree(), "idle_frame")
	i = 0
	count = false
	print("teleport event finished")
	emit_signal("finished")

		