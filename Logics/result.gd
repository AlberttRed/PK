extends Node

var value = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func clear_all():
	print("result cleared!")
	for c in get_children():
		remove_child(c)
		GLOBAL.queue(c)
		
func add(prop, v):
	if has_node(prop):
		tile_prop_priorities(prop, v)
	else:
		var node = load("res://Logics/result.tscn").instance()
		node.set_name(prop)
		add_child(node)
		node.set_owner(self)
		node.value = v
	
func get(prop):
	if has_node(prop):
		return get_node(prop).value
	else:
		print("El result no té la propietat: " + str(prop))
		return null
	
func has(prop):
	return has_node(prop)
	
func remove(prop):
	remove_child(prop)

func tile_prop_priorities(prop, v):
	if prop == "Tipo":
		if get_node(prop).value == null or v > get_node(prop).value:
			get_node(prop).value = v 
	
