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

func _process(delta):
	if count:
		i += 1
		
func _init():
	add_user_signal("finished_movement")
	add_user_signal("pressed")
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
	
func destroy(node):
	queue(node)
	print("DELETED: " + node.get_name())
	for n in get_tree().get_nodes_in_group(node.get_name()):
		if n.is_in_group("Evento") and !n.is_in_group("NPC"):
			if n.running:
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
		
func move(which_key, last_movement = true):
#	var event = InputEventKey.new()
#	event.scancode = KEY_UP
##	InputMap.add_action('ui_up')
#	InputMap.action_add_event('ui_up', event)
#	var event = InputEventKey.new()
#	event.scancode = KEY_UP
#	get_tree().input_event(event)

	#Input.action_press("ui_up")
	#ProjectSettings.get("Player").can_interact = true
	#if ProjectSettings.get("Player").jumping:

		#yield(get_tree().create_timer(5.0), "timeout")
	#		if !Input.is_action_pressed("ui_up"):
#		if move == which_key.size()-1:
#			Input.action_release("ui_" + which_key[move] + "_event")		
		#move += 1
#		yield(get_tree(), "idle_frame")
#	Input.action_release("ui_" + which_key[which_key.size()-1] + "_event")

	while i < 6:
		i += 1
		Input.action_press("ui_" + which_key + "_event")
		yield(get_tree(), "idle_frame")
##		if !Input.is_action_pressed("ui_up"):
#	if last_movement:
	Input.action_release("ui_" + which_key + "_event")		
#		#yield(get_tree(), "idle_frame")
	i = 0
	#ProjectSettings.get("Player").can_interact = false
#	count = false

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
		for p in ProjectSettings.get("Player").trainer.party:
			print(p.get_name())
			if p.hasMove(CONST.MOVES.SURF):
				pkmn_selected = p
				print("SÍ")
				return true
	print("NO")
	return false
	
func CanDoCut():
	if hasMedal(CONST.MEDALS.CASCADA):
		for p in ProjectSettings.get("Player").trainer.party:
			print(p.get_name())
			if p.hasMove(CONST.MOVES.CORTE):
				pkmn_selected = p
				print("SÍ")
				return true
	print("NO")
	return false
	
func CanDoStrength():
	if hasMedal(CONST.MEDALS.PANTANO):
		for p in ProjectSettings.get("Player").trainer.party:
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
