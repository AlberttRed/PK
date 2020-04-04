extends Node

class_name EventMovement
var event
var Target
var movesArray :Array
var moved = false
var moving = false
var i = 0

# Called when the node enters the scene tree for the first time.
func _init():
	#set_process(true)
	add_user_signal("moved")
	
func add(_commands, _target, _parentEvent = null):
	if movesArray != _commands or Target != _target:
		i = 0
	movesArray = _commands
	Target = _target
	event = _parentEvent
#	if event != null:
#		event.init_move()
	if Target != null:
		Target.init_move()
	#set_process(true)
	
func _process(delta):
	print("process " + self.get_name())
	if !movesArray.empty() and !moving:
		#var moving_event = actual_event
		var event_move = ""
		print("lololololo")
		var movement_commands = movesArray
		#Target = movement_target.front()
		if Target == GAME_DATA.PLAYER:#ProjectSettings.get("Player"):
			event_move = "_player"
		print(str(movesArray.size()) + ", " + str(moving) + ", " + str(Target.get_name()))
		if movesArray.size() != 0 and Target != null:# and !moved:
			moving = true
			Target.being_controlled = true
			while i < movesArray.size():
				while !Target.can_move and !Target.jumping:
					yield(get_tree(), "idle_frame")
				if movesArray[i].begins_with("wait"):					
					var t = Timer.new()
					var first_par = movesArray[i].find("(")+1
					var second_par = movesArray[i].find(")")
					var ms = movesArray[i].substr(movesArray[i].find("(")+1, second_par - first_par)
					print("waiting time: " + str(ms))
					t.set_wait_time(float(ms)/10.0)
					t.set_one_shot(true)
					self.add_child(t)
					t.start()
					yield(t, "timeout")
					print("TIME")
				elif movesArray[i].begins_with("look"):					
					var direction = movesArray[i].substr(movesArray[i].find("_")+1, movesArray[i].length() - movesArray[i].find("_")+1)
					Target.look(direction)
				elif movesArray[i].begins_with("next"):					
					Target.get_node("Sprite").frame = Target.get_node("Sprite").frame+1
				elif movesArray[i].begins_with("previous"):					
					Target.get_node("Sprite").frame = Target.get_node("Sprite").frame-1
				else:
				#for i in range(movesArray.size()):
					print(str(i) + " UN PAS " + movesArray[i])
					if Target.jumping and event != null:
						yield(Target, "jump")
					print("Through: " + str(Target.Through))
					Target.set_all_process(true)
					Input.action_press("ui_" + movesArray[i] + "_event" + event_move)
					yield(Target, "controlled_move")
					print("aaaaaaaaaaaasasasas")
					Input.action_release("ui_" + movesArray[i] + "_event" + event_move)
					Target.set_all_process(false)
#					GLOBAL.input_action_press("ui_" + movesArray[i] + "_event" + event_move)
#					yield(GLOBAL, "pressed")
				if movesArray == movement_commands:
					i += 1
				else:
					movement_commands = movesArray
			print("STOP ")
			#moved = true
			#moving = false
#			set_physics_process(false)
#			finish_move()
#			#emit_signal("finished_movement")
#			if get_parent() != null:
#				get_parent().cmd_move_on = false
			while Target.get_node("AnimationPlayer").is_playing():
					yield(get_tree(), "idle_frame")
			Target.being_controlled = false
			#remove_movement(moving_event)
			#moving_event = null
			i = 0
			movesArray = []
			movement_commands = []
			
			moving = false
			
			#emit_signal("moved")
			#set_process(false)
			print("c'est fini")
			Target.release_move()
			if event != null:
				event.current_page.cmd_move_on = false
				event.current_page.finished_command()

			
			
