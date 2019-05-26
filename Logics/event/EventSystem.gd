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
	set_physics_process(true)

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
	print("Added event: " + str(evento.get_name()))
	if running_events.find(evento) == -1:
		if runner != null: 
			evento.eventTarget = runner 
		running_events.push_back(evento)
		print("size: " + str(running_events.size()))
	
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
	running_events.pop_front()
	print("Removed event: " + str(e))
	
func get_next_event():
	return running_events.front()
	
func _physics_process(delta):
	
	if !movement_commands.empty():
		print("lololololo")
		var movesArray = movement_commands.front()
		var Target = movement_target.front()
		if movesArray.size() != 0 and Target != null and !moved:
			if Target == ProjectSettings.get("Player"):
				if i < movesArray.size() and !moved and !moving:
					#set_physics_process(false)
					moving = true
					i = 0
					for move in movesArray:
						print(str(i) + " UN PAS " + move)
						if ProjectSettings.get("Player").jumping:
							yield(ProjectSettings.get("Player"), "jump")
						Input.action_press("ui_" + move + "_event_player")
						yield(ProjectSettings.get("Player"), "move")
						Input.action_release("ui_" + move + "_event_player")
						i += 1
				print("STOP ")
				moved = true
				moving = false
				i = 0
	#			set_physics_process(false)
	#			while ProjectSettings.get("Player").animationPlayer.is_playing():
	#				yield(get_tree(), "idle_frame")
	#			finish_move()
	#			#emit_signal("finished_movement")
	#			if get_parent() != null:
	#				get_parent().cmd_move_on = false
			else:
				if i < movesArray.size() and !moved and !moving:
					#set_physics_process(false)
					Target.can_interact = true		
					moving = true
					Target.can_interact = true
					for move in movesArray:
						print(str(i) + " UN PAS " + move)
						if Target.jumping:
							yield(Target, "jump")
						Input.action_press("ui_" + move + "_event")
						yield(Target, "move")
						Input.action_release("ui_" + move + "_event")
						i += 1
					Target.can_interact = false
				print("STOP ")
				moved = true
				moving = false
				i = 0
				while Target.animationPlayer.is_playing():
					yield(get_tree(), "idle_frame")
	#			finish_move(Target)
				remove_movement()
	#			#emit_signal("finished_movement")
	#			if get_parent() != null:
	#				get_parent().cmd_move_on = false
		else:
			i=0
			moved = true
			moving = false
#				if get_parent() != null:
#					get_parent().cmd_move_on = false
			set_physics_process(true)
			#print("move event finished")
			remove_movement()
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
	
func remove_movement():
	movement_commands.pop_front()
	movement_target.pop_front()
	set_physics_process(true)