extends Node

var value = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func clear():
	for c in get_children():
		GLOBAL.queue(c)
		
func add_prop(prop, v):
	var node = load("res://Logics/result.tscn").instance()
	node.set_name(node)
	add_child(node)
	node.set_owner(self)
	node.value = v
