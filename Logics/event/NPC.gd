extends "res://Logics/event/Event.gd"

var player
var current_page
var event_running = false
var finished_cmds_count = 0

export(bool) var Trainer = false
export(int, "NPC, Object")var event_type = 0
export (bool)var BlockPlayerAtEnd = false

var event_pages

var eventTarget = null

func _init():
	._init()
	add_user_signal("move")
	add_user_signal("step")
	add_user_signal("jump")
	add_user_signal("event_finished")
	add_user_signal("controlled_move")
	
func _ready():
	._ready()
	set_parent_event(get_node("pages"))
	add_to_group(get_parent().get_parent().get_name())
	get_current_page()
	current_page.load_sprite()
	#player=ProjectSettings.get("Player")
	player=GAME_DATA.PLAYER
	if event_type == CONST.EVENT.NPC:
		$Sprite.offset = $Sprite.offset + Vector2(0,4)
		$Sprite.set_position(Vector2(0,-12))
	elif event_type == CONST.EVENT.OBJECT:
		$Sprite.offset = $Sprite.offset + Vector2(0,0)
		$Sprite.set_position(Vector2(0,0))
	event_pages = get_node("pages")
	remove_child(event_pages)
	set_all_process(false)
	

func _physics_process(delta):# and !$MoveTween.is_active():
	print("physics_process " + self.get_name())
	if being_controlled:
		for dir in moves.keys():
			if Input.is_action_pressed("ui_" + dir + "_event") and can_move:
					can_move = false
					move(dir)
				
func exec(from = facing_idle[facing]):
	if !event_running:
		player.in_event = true
		print("Started event " + get_name())
		GLOBAL.running_events.push_back(self)
		event_running = true
		get_current_page()
		while !player.can_move:
			yield(get_tree(), "idle_frame")
		if (current_page == null):
			return
		if current_page.Imagen != null and current_page.Imagen.get_width() / 32 > 1 and !current_page.DirectionFix:
			get_node("Sprite").frame = from#0
		print(current_page.get_name())
		if current_page.Imagen != null and current_page.Imagen.get_width() / 32 > 1 and !current_page.DirectionFix:
			print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" + get_name() + " " + str(facing_idle[facing]))
			current_page.get_node("Sprite").frame = facing_idle[facing]
		
		if Trainer and !trainer.is_defeated:
			GUI.show_msg(trainer.before_battle_message)
			yield(GUI.msg, "finished")
			GUI.start_battle(trainer.double_battle, GAME_DATA.trainer, trainer)#, null, trainer)
		else:
			current_page.run()
			yield(current_page, "finished_page")
			player.set_can_interact(!BlockPlayerAtEnd)
			player.in_event = BlockPlayerAtEnd
#			GLOBAL.running_events.erase(self)
#			event_running = false
#			print("Finalized event " + get_name())
#			emit_signal("event_finished")
			
				
func set_parent_event(pages):
	if pages.get_child_count() > 0:
		for p in pages.get_children():
			set_parent_event(p)
			
	if pages.is_in_group("CMD"):
		pages.parentEvent = self
	elif pages.is_in_group("PAGE"):
		pages.parentEvent = self
		pages.add_to_group("Evento")
		if pages.PlayerTouch:
			pages.add_to_group("PlayerTouch")
			if !is_connected("area_entered",self,"_execPlayerTouch"):
				#print("CONECTED PlayerTouch")
				connect("area_entered",self,"_execPlayerTouch")
		if pages.EventTouch:
			pages.add_to_group("EventTouch")
			if !is_connected("area_entered",self,"_execEventTouch"):
				connect("area_entered",self,"_execEventTouch")
		if pages.Pasable:
			pages.add_to_group("Pasable")
		if pages.Interact:
			pages.add_to_group("Interact")
			
func exec_this_page(page):
	print("exec_this-page")
	var p
	if (page<0 or page>=get_node("pages").get_child_count()):
		return
	p = get_node("pages").get_child(page)
	player.set_can_interact(false)
	p.run()
	yield(p, "finished")
	print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
	player.set_can_interact(!BlockPlayerAtEnd)


func _execEventTouch(target):
	if current_page.Pasable:
		if target.is_in_group("Evento"):
			exec()

func _execPlayerTouch(target):
		if target.get_name() == "Player":
			print("PLAYER TOUCH")
			target.can_interact = current_page.Paralelo
			eventTarget = target
			exec()

func get_current_page():
	current_page = $pages.get_child(0)
	for c in $pages.get_children():
			if !c.condition1.empty():
				print("CONDITION: " + c.condition1 + ": " + str(GLOBAL.get_node(c.condition1).get_state()))
				if GLOBAL.get_node(c.condition1).get_state():
					print(GLOBAL.get_node(c.condition1).get_state())
					current_page = c
			elif !c.condition2.empty():
				if GLOBAL.get_node(c.condition2).get_state():
					current_page = c
			elif !c.condition3.empty():
				if GLOBAL.get_node(c.condition3).get_state():
					current_page = c
	

func is_in_group(parent):
	return current_page.is_in_group(parent)
	
#Funció per eliminar el nodo de l'evento. Només potfer queue_free() si està dins l SceneTree	
func remove():
	print(get_name() + " DEW")
	if is_inside_tree():
		queue_free()
	else:
		call_deferred("free")
	
func set_page(page):
	current_page = page


func save():
	var save_dict = {
		"filename" : get_filename(),
		"name" : get_name(),
		"x_position" : actual_position.x, # Vector2 is not supported by JSON
		"y_position" : actual_position.y, # Vector2 is not supported by JSON
		"event_running" : event_running,
		"Through" : Through,
		"speed_animation" : speed_animation,
		"step_speed" : step_speed,
		"can_move" : can_move,
		"facing" : facing,
		"moved" : moved,
		"jumping" : jumping,
		"surfing" : surfing,
		"pushing" : pushing,
		"running" : running,
		"in_event" : in_event,
		"last_facing" : last_facing,
		"can_interact" : can_interact,
		"being_controlled" : being_controlled
	}
	return save_dict

func finished_command():
	finished_cmds_count = finished_cmds_count+1
	print("EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE")
	print("cmds_finished: " + str(finished_cmds_count) + ", total cmds: " + str(current_page.get_children().size()))
	if finished_cmds_count == current_page.get_children().size() - 2: #Li resto dos pq l'event_page té un Sprite i AnimationPlayer que no se d'on surten...
		GLOBAL.running_events.erase(self)
		event_running = false
		finished_cmds_count = 0
		print("OUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU")
		print("Finalized event " + get_name())
		remove_child(event_pages)
		emit_signal("event_finished")
		
func set_all_process(state):
	print("SET " + get_name() + " ALL PROCESS " + str(state))
	set_process(state)
	set_physics_process(state)
	set_physics_process_internal(state)
