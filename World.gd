extends Node2D

export(bool) var play_intro = false
export(String, FILE, "*.tscn") var actual_scene
export(Vector2) var initial_position
var Player = preload("res://Logics/event/Player.tscn").instance()#preload("res://Player.tscn").instance()

var faded = false
func _ready():
	print("World get ready")
	#add_child(load("res://Pueblo_Paleta.tscn").instance())
	GAME_DATA.EVENTS_LOADED = $CanvasModulate/Eventos_
	ProjectSettings.set("Global_World", self)
	ProjectSettings.set("Eventos", get_node("CanvasModulate/Eventos_"))
	if play_intro:
		GUI.start_intro()
	else:
		GAME_DATA.new_game()
	yield(GAME_DATA, "start")
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
