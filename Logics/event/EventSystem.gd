extends Node
class_name EventSystem

#const Evento = preload('res://Logics/event/event.gd')

var running_events :Array = []
var actual_event
var event_runner = null


var movement_target :Array = []
var movement_commands :Array = []
var moved = false
var moving = false
var i = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(false)
	set_physics_process_internal(false)
	set_process(false)

func _process(delta):
	if !running_events.empty() or running_events.size() != 0:
		actual_event = get_next_event()
		if !actual_event.running:
			print("pam")
			event_runner = actual_event.eventTarget
			actual_event.running = true
			actual_event.exec()
			yield(actual_event, "event_finished")
			remove_first()
#		else:
#			print(str(running_events.size()))
#			#print("event " + actual_event.get_name() + " is already running!")

func add_event(evento, runner = null):
	if running_events.find(evento) == -1:
		if runner != null: 
			evento.eventTarget = runner 
		running_events.push_back(evento)
		print("Added event: " + str(evento.get_name()))
		print("size: " + str(running_events.size()))
	else:
		print("Event " + evento.get_name() + " is already loaded.")
	
func remove_event(evento):
	running_events.erase(evento)
	print("Removed event: " + str(evento.get_name()))
	
func remove_last():
	var e = running_events.back()
	running_events.erase(e)
	#running_events.pop_back()
	print("Removed event: " + str(e.get_name()))
	
func remove_first():
	event_runner = null
	var e = running_events.front().get_name()
	running_events.front().running = false
#	if ProjectSettings.get("Player").active_events.has(running_events.pop_front()):
#		ProjectSettings.get("Player").active_events.erase(running_events.pop_front())
	running_events.pop_front()
	print("Removed event: " + str(e))

	
func get_next_event():
	return running_events.front()
	
func _physics_process(delta):
	print("ou mama")
	if !movement_commands.empty() and !moving:
		var moving_event = actual_event
		var event_move = ""
		print("lololololo")
		var movesArray = movement_commands.front()
		var Target = movement_target.front()
		if Target == GAME_DATA.PLAYER:#ProjectSettings.get("Player"):
			event_move = "_player"
		print(str(movesArray.size()) + ", " + str(moved) + ", " + str(Target))
		if movesArray.size() != 0 and Target != null:# and !moved:
			moving = true
			Target.being_controlled = true

			for move in movesArray:
				print(str(i) + " UN PAS " + move)
				if GAME_DATA.PLAYER.jumping:#ProjectSettings.get("Player").jumping:
					yield(GAME_DATA.PLAYER, "jump")
					#yield(ProjectSettings.get("Player"), "jump")
				Input.action_press("ui_" + move + "_event" + event_move)
				yield(Target, "move")
				Input.action_release("ui_" + move + "_event" + event_move)
			print("STOP ")
			#moved = true
			#moving = false
#			set_physics_process(false)
			#while ProjectSettings.get("Player").animationPlayer.is_playing():
			while GAME_DATA.PLAYER.animationPlayer.is_playing():
				yield(get_tree(), "idle_frame")
#			finish_move()
#			#emit_signal("finished_movement")
#			if get_parent() != null:
#				get_parent().cmd_move_on = false
			Target.being_controlled = false
			remove_movement(moving_event)
			moving_event = null
			moved = true
			moving = false
	#				if get_parent() != null:
	#					get_parent().cmd_move_on = false

		#print("move event finished")

		#finish_move(Target)
		#emit_signal("finished_movement")
	#
#func finish_move(Target):
#
#	if Target == ProjectSettings.get("Player"):
#		Target.can_interact = true
#		#Target.being_controlled = false
#	print("move event finished")
#	executing = false
#	if !parentEvent.running:
#		parentEvent.erase_from_player()

func add_movement(target, moves):
	movement_commands.push_back(moves)
	movement_target.push_back(target)
	
func remove_movement(moveming_event):
	if running_events.find(moveming_event) != -1:
		running_events[running_events.find(moveming_event)].current_page.cmd_move_on = false
	movement_commands.pop_front()
	movement_target.pop_front()
#	set_physics_process(true)
