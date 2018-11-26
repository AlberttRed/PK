extends Node2D

export(String, FILE, "*.tscn") var N_connection
export(String, FILE, "*.tscn") var S_connection
export(String, FILE, "*.tscn") var E_connection
export(String, FILE, "*.tscn") var W_connection

export(Vector2) var N_connection_pos
export(Vector2) var S_connection_pos
export(Vector2) var E_connection_pos
export(Vector2) var W_connection_pos

var Player = ProjectSettings.get("Player") 
var target = ProjectSettings.get("Global_World")
var comptador = 0

	
func _ready():
	pass
		
#
#
func init():
	comptador += 1
	target.get_node("CanvasModulate/CapaTerra_").z_index = -2
	print("Map init count: " + str(comptador))
	ProjectSettings.set("Previous_Map", ProjectSettings.get("Actual_Map"))
	ProjectSettings.set("Actual_Map", self)	

#	if Player.get_parent() != null:
#		Player.get_parent().remove_child(Player)
#		target.get_node("CanvasModulate/Eventos_").add_child(Player)
	
func set_connections():
	var Scene
	if N_connection != null and N_connection_pos != null:
		if target.get_parent().get_tree().get_nodes_in_group(N_connection.split("/")[2].split(".")[0]).size() <= 0:		
			print("N connected")
			Scene = load(N_connection).instance()
			load_map(false, Scene, N_connection_pos)
	if S_connection != null and S_connection_pos != null:
		if target.get_parent().get_tree().get_nodes_in_group(S_connection.split("/")[2].split(".")[0]).size() <= 0:		
			print("S connected")
			Scene = load(S_connection).instance()
			load_map(false, Scene, S_connection_pos)
	if E_connection != null and E_connection_pos != null:
		if target.get_parent().get_tree().get_nodes_in_group(E_connection.split("/")[2].split(".")[0]).size() <= 0:		
			print("E connected")
			Scene = load(E_connection).instance()
			load_map(false, Scene, E_connection_pos)
	if W_connection != null and W_connection_pos != null:
		if target.get_parent().get_tree().get_nodes_in_group(W_connection.split("/")[2].split(".")[0]).size() <= 0:		
			print("W connected")
			Scene = load(W_connection).instance()
			load_map(false, Scene, W_connection_pos)
		
func load_map(deletePrevious, scene = self, pos = null):
	print("Loaded Map: " + scene.get_name())
#	ProjectSettings.set("Previous_Map", ProjectSettings.get("Actual_Map"))
#	ProjectSettings.set("Actual_Map", scene)	


	for N in scene.get_children():		
		N.add_to_group(scene.get_name())

		if (N.get_name().split("_")[0].replace("@", "") + "_") == "Area2D_":
			N.parent_map = scene
			
		scene.remove_child(N)
		target.get_node("CanvasModulate").get_node(N.get_name()).add_child(N)
		N.set_owner(target.get_node("CanvasModulate").get_node(N.get_name().split("_")[0].replace("@", "") + "_"))
		if pos != null:
			N.set_position(pos)
		else:
			N.set_position(scene.get_position())
				
	for evento in target.get_node("CanvasModulate/Eventos_/Eventos_").get_children():
				var position = evento.get_global_position()
				evento.add_to_group(scene.get_name())
				target.get_node("CanvasModulate/Eventos_/Eventos_").remove_child(evento)
				target.get_node("CanvasModulate/Eventos_").add_child(evento)
				evento.set_owner(target.get_node("CanvasModulate/Eventos_"))
				evento.set_position(position)
	target.get_node("CanvasModulate/Eventos_").remove_child(target.get_node("CanvasModulate/Eventos_/Eventos_"))
	
	if scene == self:
		if Player.get_parent() != null:
			Player.get_parent().remove_child(Player)
		target.get_node("CanvasModulate/Eventos_").add_child(Player)
		
	if deletePrevious:
		GLOBAL.destroy(ProjectSettings.get("Previous_Map"))
#		for node in get_tree().get_nodes_in_group(ProjectSettings.get("Previous_Map").get_name()):
#			if node.get_name() != "Eventos_" and node != get_parent().get_parent().get_parent():
#				node.call_deferred("free")
#			elif node == get_parent().get_parent().get_parent():
#				node.hide()
		#Player.set_position(Vector2(-16, -48))
		
#				var position_ev = evento.get_position()
#				N.remove_child(evento)
#				target.get_node("CanvasModulate").get_node(N.get_name()).add_child(evento)
#				evento.set_owner(target.get_node("CanvasModulate").get_node(N.get_name().split("_")[0].replace("@", "") + "_"))


#				if pos != null:
#					N.set_position(pos)
#				else:
				#N.set_position(scene.get_position()				evento.set_position(position_ev)

				
				


