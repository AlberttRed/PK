extends Node2D

export(String, FILE, "*.tscn") var actual_scene
var Player = preload("res://Player.tscn").instance()

var faded = false
func _ready():
	print("World get ready")
	#add_child(load("res://Pueblo_Paleta.tscn").instance())
	ProjectSettings.set("Global_World", self)
	ProjectSettings.set("Eventos", get_node("CanvasModulate/Eventos_"))
	ProjectSettings.set("Actual_Map", load(actual_scene).instance())
	ProjectSettings.get("Actual_Map").load_map(false)

#	Player.set_position(Vector2(-16, -48))
	#ProjectSettings.get("Actual_Map").init()
	#get_child(0).init(Vector2(-16, -48))
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
