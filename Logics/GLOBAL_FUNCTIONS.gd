extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
	
func destroy(node):
	if node.is_inside_tree():
		node.propagate_call("queue_free", [])
	else:
		node.propagate_call("call_deferred", ["free"])
	print("DELETED: " + ProjectSettings.get("Previous_Map").get_name())

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
