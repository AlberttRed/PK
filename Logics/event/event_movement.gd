extends Node

class_name EventMovement
var event
var Target
var movesArray :Array = []
var moved = false
var moving = false
var i = 0

# Called when the node enters the scene tree for the first time.
func _init():
	set_process(true)
	
func add(_commands, _target, _parentEvent):
	if movesArray != _commands or Target != _target:
		i = 0
	movesArray = _commands
	Target = _target
	event = _parentEvent
	set_process(true)
	
func _process(delta):
	if !movesArray.empty() and !moving:
		#var moving_event = actual_event
		var event_move = ""
		print("lololololo")
		var movement_commands = movesArray
		#Target = movement_target.front()
		if Target == ProjectSettings.get("Player"):
			event_move = "_player"
		print(str(movesArray.size()) + ", " + str(moving) + ", " + str(Target))
		if movesArray.size() != 0 and Target != null:# and !moved:
			moving = true
			Target.being_controlled = true
			while i < movesArray.size():
				
			#for i in range(movesArray.size()):
				print(str(i) + " UN PAS " + movesArray[i])
				if ProjectSettings.get("Player").jumping:
					yield(ProjectSettings.get("Player"), "jump")
				Input.action_press("ui_" + movesArray[i] + "_event" + event_move)
				yield(Target, "move")

				Input.action_release("ui_" + movesArray[i] + "_event" + event_move)
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
			while ProjectSettings.get("Player").animationPlayer.is_playing():
					yield(get_tree(), "idle_frame")
			Target.being_controlled = false
			#remove_movement(moving_event)
			#moving_event = null
			i = 0
			movesArray = []
			movement_commands = []
			event.current_page.cmd_move_on = false
			moving = false
			set_process(false)
			print("c'est fini")
			