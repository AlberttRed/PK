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
	#Player = ProjectSettings.get("Player")
	Player = GAME_DATA.PLAYER
	add_to_group("CMD")
	
func _process(delta):
	print("process1 " + self.get_name())
	if count:
		i += 1

func run():
	print("teleport event started")
	if Map_XY != null and Player != null:
#		while Player.get_moving():
#			yield(get_tree(), "idle_frame")
		if !world_scene.empty():
#			Player.get_parent().remove_child(Player)
				print("act: " + GAME_DATA.ACTUAL_MAP.get_name())
				for n in ProjectSettings.get("Global_World").get_node("CanvasModulate").get_node("MapArea_").get_children():
					if n.is_in_group(GAME_DATA.ACTUAL_MAP.get_name()):
						ProjectSettings.get("Global_World").get_node("CanvasModulate").get_node("MapArea_").remove_child(n)
				GAME_DATA.ACTUAL_MAP.area.queue_free()
				Scene = load(world_scene).instance()
				print("Scene to teleport: " + Scene.get_name())
	#			print("World: " + wworld.get_name())
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
	parentPage.finished_command()
	emit_signal("finished")

		
