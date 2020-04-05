extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var choice_selected = "" setget set_choice_selected, get_choice_selected
var pkmn_selected = null setget set_pkmn_selected, get_pkmn_selected
var running_events = []
var i = 0
var move = 0
var count = false
var last_action_pressed = ""
var frames = 0
var framesToWait = 5
var beingPressed = false
var movingEvent = null
var threads = [Thread.new(), Thread.new(), Thread.new(),Thread.new(),Thread.new(),Thread.new()]
var active_thread = 0

func _process(delta):
	if count:
		i += 1
		
func _init():
	add_user_signal("finished_movement")
	add_user_signal("pressed")
func _ready():
	pass
	# Called when the node is added to the scene for the first time.
	# Initialization here

	
func destroy(node):
	queue(node)
	print("DELETING: " + node.get_name())
	for n in get_tree().get_nodes_in_group(node.get_name()):
		print("DELETED " + n.get_name())
		if n.is_in_group("Evento") and !n.is_in_group("NPC"):
			print(n.get_name() + " " + str(n.event_running))
			if n.event_running:
				n.hide()
				n.current_page.deleteAtEnd = true
			else:
				queue(n)
		else:
			queue(n)
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
func queue(node):
	if node.is_inside_tree():
		node.propagate_call("queue_free", [])
	else:
		node.propagate_call("call_deferred", ["free"])
		
#func move(which_key, last_movement = true):
##	var event = InputEventKey.new()
##	event.scancode = KEY_UP
###	InputMap.add_action('ui_up')
##	InputMap.action_add_event('ui_up', event)
##	var event = InputEventKey.new()
##	event.scancode = KEY_UP
##	get_tree().input_event(event)
#
#	#Input.action_press("ui_up")
#	#ProjectSettings.get("Player").can_interact = true
#	#if ProjectSettings.get("Player").jumping:
#
#		#yield(get_tree().create_timer(5.0), "timeout")
#	#		if !Input.is_action_pressed("ui_up"):
##		if move == which_key.size()-1:
##			Input.action_release("ui_" + which_key[move] + "_event")		
#		#move += 1
##		yield(get_tree(), "idle_frame")
##	Input.action_release("ui_" + which_key[which_key.size()-1] + "_event")
#
#	while i < 6:
#		i += 1
#		Input.action_press("ui_" + which_key + "_event")
#		yield(get_tree(), "idle_frame")
###		if !Input.is_action_pressed("ui_up"):
##	if last_movement:
#	Input.action_release("ui_" + which_key + "_event")		
##		#yield(get_tree(), "idle_frame")
#	i = 0
#	#ProjectSettings.get("Player").can_interact = false
##	count = false

func move_event(Target, facing, speed = 2, grid = 32):
	var direction
	match facing:
		"up":
			direction = Vector2(0, -1)
		"right":
			direction = Vector2(1, 0)
		"left":
			direction = Vector2(-1, 0)
		"down":
			direction = Vector2(0, 1)
	var startPos = Target.get_position()
	while !(Target.get_position() == (startPos + Vector2(grid * direction.x, grid * direction.y))):
		Target.move_and_collide(direction * speed)
	emit_signal("finished_movement")
		
func move_is_continuous():
		if Input.is_action_pressed(last_action_pressed):
			if frames == framesToWait:
				beingPressed = true
				return true
			else:
				frames += 1
				return false
		else:
			if Input.is_action_pressed("ui_up"):
				last_action_pressed = "ui_up"
			elif Input.is_action_pressed("ui_up_event"):
				last_action_pressed = "ui_up_event"
			elif Input.is_action_pressed("ui_right"):
				last_action_pressed = "ui_right"
			elif Input.is_action_pressed("ui_right_event"):
				last_action_pressed = "ui_right_event"
			elif Input.is_action_pressed("ui_left"):
				last_action_pressed = "ui_left"
			elif Input.is_action_pressed("ui_left_event"):
				last_action_pressed = "ui_left_event"
			elif Input.is_action_pressed("ui_down"):
				last_action_pressed = "ui_down"
			elif Input.is_action_pressed("ui_down_event"):
				last_action_pressed = "ui_down_event"
			return false

		
func release_move():
	frames = 0

func move_is_released():
		if !Input.is_action_pressed("ui_up") and !Input.is_action_pressed("ui_right") and !Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_down") and !Input.is_action_pressed("ui_up_event") and !Input.is_action_pressed("ui_right_event") and !Input.is_action_pressed("ui_left_event") and !Input.is_action_pressed("ui_down_event"):
			#last_action_pressed = ""

			return true
		return false


func get_last_move():
	return last_action_pressed
	
#func is_last_move(player_facing):
#	return ("ui_" + player_facing == last_action_pressed or "ui_" + player_facing + "_event" == last_action_pressed) and frames == 1

func is_last_move(player_facing):
	return Input.is_action_pressed("ui_" + player_facing) or Input.is_action_pressed("ui_" + player_facing + "_event") or Input.is_action_pressed("ui_" + player_facing + "_event_player")

func CanDoSurf():
	if hasMedal(CONST.MEDALS.ALMA):
		for p in GAME_DATA.PLAYER.trainer.party:
			print(p.get_name())
			if p.hasMove(CONST.MOVES.SURF):
				pkmn_selected = p
				print("SÍ")
				return true
	print("NO")
	return false
	
func CanDoCut():
	if hasMedal(CONST.MEDALS.CASCADA):
		for p in GAME_DATA.PLAYER.trainer.party:
			print(p.get_name())
			if p.hasMove(CONST.MOVES.CORTE):
				pkmn_selected = p
				print("SÍ")
				return true
	print("NO")
	return false
	
func CanDoStrength():
	if hasMedal(CONST.MEDALS.PANTANO):
		for p in GAME_DATA.PLAYER.trainer.party:
			print(p.get_name())
			if p.hasMove(CONST.MOVES.FUERZA):
				pkmn_selected = p
				print("SÍ")
				return true
	print("NO")
	return false
			
func hasMedal(medal):
	return GAME_DATA.medals.has(medal)
	
func set_choice_selected(choice):
	choice_selected = choice

func get_choice_selected():
	return choice_selected

func set_pkmn_selected(pkmn):
	pkmn_selected = pkmn

func get_pkmn_selected():
	return pkmn_selected
	
	
func reload_events():
	for c in get_tree().get_root().get_node("World/CanvasModulate/Eventos_").get_children():
		if c.get_name() != "Player" and c.is_in_group("Evento"):
			c.get_current_page()
			
func input_action_press(action):
		Input.action_press(action)
		var t = Timer.new()
		t.set_wait_time(float(0.3)*100)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		print("ai mama")
		Input.action_release(action)
		emit_signal("pressed")
		
func starts(deletePrevious, scene = self, pos = null):
	threads[active_thread].start(self, "_map", [deletePrevious, scene, pos])
	active_thread = active_thread + 1

func _map(userdata):
	load_map(userdata[0], userdata[1], userdata[2])
	
		
func load_map(deletePrevious, scene = self, pos = null):
	#print("Loaded Map: " + scene.get_name())
#
#	scene.init()
#	if deletePrevious:
#			print("DELETED " + GAME_DATA.PREVIOUS_MAP.get_name())
#			GLOBAL.destroy(GAME_DATA.PREVIOUS_MAP)

#	if pos != null:
#		print("set " + scene.get_name() + " tile offset: " + str(-pos))
#		scene.tile_offset = -pos

	

#		world.add_child(scene)
#		scene.set_position(pos)
#		var capa = scene.get_node("CapaTerra_")
#		scene.remove_child(capa)
#		world.get_node("CanvasModulate").get_node(capa.get_name().split("_")[0].replace("@", "") + "_").add_child(capa)
#		capa.add_to_group(scene.get_name())

#
#	scene.strength_on = false
#	if pos != null:
#		scene.tile_offset = -pos
#		scene.position = scene.get_position() + pos
#
#	for N in scene.get_children() :		
#		if N.get_class() != "Node":
#			if pos != null:
#				N.visible = false
#		#print("looping load: " + scene.get_name())
##		if !N.is_in_group("ignore"):
##			#print("N tratada: " + N.get_name())
##
#			N.add_to_group(scene.get_name())
#
#			#if (N.get_name().split("_")[0].replace("@", "") + "_") == "MapArea_":
#			if N.get_name() == "MapArea_":
#				scene.area = N
#				N.parent_map = scene
#
#			scene.remove_child(N)
#			#print(N.get_name())
#			#print("ADD " + N.get_name() + " INTO " + world.get_node("CanvasModulate").get_node(N.get_name()).get_name())
#			ProjectSettings.get("Global_World").get_node("CanvasModulate").get_node(N.get_name()).add_child(N)
#			#N.set_owner(world.get_node("CanvasModulate").get_node(N.get_name().split("_")[0].replace("@", "") + "_"))
	for N in scene.get_children() :		
		if pos != null:
			if N.get_groups().has(scene.get_name()):
				#print(n.get_name() + " repositioned")
			#	print("Before " + str(n.get_position()))
				N.set_position(N.get_position() + pos)
			#	print("After " + str(n.get_position()))
				if N.get_class() != "Node" and !N.visible:
					print(scene.get_name() + " showwww")
					N.visible = true

	#ProjectSettings.get("Global_World").get_node("CanvasModulate/Eventos_/Eventos_").remove_and_skip()	
		
				#if N.get_name() == "Eventos_":
#				N.remove_and_skip()
		#			if pos != null:
#				N.set_position(pos)
#			else:
#				if (N.get_name().split("_")[0].replace("@", "") + "_") == "MapArea_" or (N.get_name().split("_")[0].replace("@", "") + "_") == "Areas_":# and scene == self:
#					N.set_position(area_pos)
#				else:
#					N.set_position(scene.get_position())

#	for evento in world.get_node("CanvasModulate/Eventos_/Eventos_").get_children():
#			#var position = evento.get_position()
#
#				#p.propagate_call("set_physics_process", false)
#			evento.add_to_group(scene.get_name())
#			world.get_node("CanvasModulate/Eventos_/Eventos_").remove_child(evento)
#			world.get_node("CanvasModulate/Eventos_").add_child(evento)
#			evento.set_owner(world.get_node("CanvasModulate/Eventos_"))

	#world.get_node("CanvasModulate/Eventos_").remove_child(world.get_node("CanvasModulate/Eventos_/Eventos_"))
#	for encounter_area in target.get_node("CanvasModulate/EncounterAreas_/EncounterAreas_").get_children():
#		encounter_area.add_to_group(scene.get_name())
#	if pos != null:
#		reposition(scene, pos)	
#	if pos == null:
#		if GAME_DATA.PLAYER.get_parent() != null:
#			GAME_DATA.PLAYER.get_parent().remove_child(GAME_DATA.PLAYER)
#		ProjectSettings.get("Global_World").get_node("CanvasModulate/Eventos_").add_child(GAME_DATA.PLAYER)
#
#	scene.loaded = true
	
	
#	print("DELETE SCENE : " + scene.get_name())
#	for c in scene.get_children():
#		print("scene child: " + c.get_name())
	#world.remove_child(scene)
	if deletePrevious:
		#print("DELETED " + GAME_DATA.PREVIOUS_MAP.get_name())
		if GAME_DATA.PREVIOUS_MAP.N_scene != null:
			GLOBAL.destroy(GAME_DATA.PREVIOUS_MAP.N_scene)
		GLOBAL.destroy(GAME_DATA.PREVIOUS_MAP)
		#GLOBAL.destroy(ProjectSettings.get("Previous_Map"))
	scene.emit_signal("loaded")

func set_connections(scene_from):
	var Scene
	if scene_from.N_connection != null and scene_from.N_connection_pos != null:
		#print("NNNNNNNNNNNNNNNNNNNNN " + self.get_name())
		Scene = scene_from.N_connection
		var scene_name = scene_from.N_connection.get_path().split("/")[4].split(".")[0]
		if ProjectSettings.get("Global_World").get_parent().get_tree().get_nodes_in_group(scene_name).size() <= 0:		
			#print("N connected: " + str(scene_name))#str(N_connection.split("/")[3].split(".")[0]))
			
			#print(get_name() + " " + str(position))
			
			#world.thread.start(self, "_load_connection", [false, Scene, N_connection_pos + position])
			
			#if world.loading:
			scene_from.N_scene = Scene.instance()
			#start(self, "_map", [false, scene_from.N_scene, scene_from.N_connection_pos + scene_from.position])
			call_deferred("load_map", false, scene_from.N_scene, scene_from.N_connection_pos + scene_from.position)
			#else:
				#print("NOT LOADING")
			#	world.thread.start(self, "_thread_function", [false, Scene, N_connection_pos + position])
#
		#	world.thread.start(self, "load_map", [false, N_scene, N_connection_pos + position])
			#thread.wait_to_finish()
			#yield(self.load_map(false, N_scene, N_connection_pos + position), "loaded")
#	if !S_connection.empty() and S_connection_pos != null:
#		print("SSSSSSSSSSSSSSSSSSSSS")
#		Scene = load(S_connection).instance()
#		if world.get_parent().get_tree().get_nodes_in_group(Scene.get_name()).size() <= 0:		
#			print("S connected: " + str(Scene.get_name()))
#			S_scene = Scene.instance()
#			load_map(false, S_scene, S_connection_pos)
#	if !E_connection.empty() and E_connection_pos != null:
#		print("EEEEEEEEEEEEEEEEEEEEEE")
#		Scene = load(E_connection).instance()
#		if world.get_parent().get_tree().get_nodes_in_group(Scene.get_name()).size() <= 0:		
#			print("E connected: " + str(Scene.get_name()))
#			E_scene = Scene.instance()
#			load_map(false, E_scene, E_connection_pos)
#	if !W_connection.empty() and W_connection_pos != null:
#		print("WWWWWWWWWWWWWWWWWWWWWWWW")
#		Scene = load(W_connection).instance()
#		if world.get_parent().get_tree().get_nodes_in_group(Scene.get_name()).size() <= 0:		
#			print("W connected: " + str(Scene.get_name()))
#			W_scene = Scene.instance()
#			load_map(false, W_scene, W_connection_pos)
