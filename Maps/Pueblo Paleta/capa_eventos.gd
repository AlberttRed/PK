extends YSort


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func initialize(position):
	print("AAAAAAAAAAAAAA")
	set_position(get_position() + position)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func reparent(data):
	var scene_name = get_name()
	#print(scene_name)
	get_parent().remove_child(self)
	GAME_DATA.WORLD.get_node("CanvasModulate/" + scene_name).add_child(self)
	set_owner(GAME_DATA.WORLD.get_node("CanvasModulate/" + scene_name))
