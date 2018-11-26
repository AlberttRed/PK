extends Node

export(NodePath) var Evento
export(Vector2) var Map_XY
var t

func _init():
	add_user_signal("finished")

func _ready():
	pass

func run():
	if Evento != null and Map_XY != null:
		get_node("/root/world/" + Evento).set_position(Map_XY)