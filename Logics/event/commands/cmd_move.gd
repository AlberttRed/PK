extends Node

export(NodePath) onready var nodePath
var Target setget set_Target,get_Target
#Cada posició será una comanda per moure el jugador. Comandes disponibles up, left, right, down, look_up, look_left, look_right, look_down
export(Array, String) var movesArray

var direction = Vector2(0,0)
var startPos = Vector2(0,0)
var moving = false setget set_moving,get_moving
var can_interact = true setget set_can_interact,get_can_interact
var moved = false
const SPEED = 2
const GRID = 32
var executing = false

var Event
var parentEvent = null
var world


var sprite
var animationPlayer
var i
var step2 = false
var up = false
var down = false
var left = false
var right = false
var continuous = false
var frameCount = 0
var framesStopped = 2
var resultUp
var resultDown
var resultLeft
var resultRight

func _init():
	add_user_signal("finished")
	add_user_signal("step")
	add_user_signal("finished_movement")
	#set_physics_process(false)

func _ready():
	set_physics_process(false)
	add_to_group("CMD")
	
func run():
	executing = true
	#set_physics_process(true)
	print("move event started")
	if GLOBAL.movingEvent == null:
		if nodePath.is_empty():# == null:
			Target = ProjectSettings.get("Player")
			print("BEING CONTROLLED")
			#Target.can_interact = false
		else:
			Target = get_node(nodePath)
	else:
		Target = GLOBAL.movingEvent
	animationPlayer = Target.get_node("AnimationPlayer")
	Target.world = Target.get_world_2d().get_direct_space_state()
	i = 0
	moved = false
	print(str(movesArray.size()) + " and " + str(Target) + " and " + str(!moved))
	#get_parent().cmd_move_on = true
	Target.move.add(movesArray, Target, parentEvent)
	#EVENTS.add_movement(Target, movesArray)
	executing = false
	emit_signal("finished")

#func _physics_process(delta):
#	if movesArray.size() != 0 and Target != null and !moved:
#		if Target == ProjectSettings.get("Player"):
#			if i < movesArray.size() and !moved and !moving:
#				set_physics_process(false)
#				moving = true
#				for move in movesArray:
#					print(str(i) + " UN PAS " + move)
#					if ProjectSettings.get("Player").jumping:
#						yield(ProjectSettings.get("Player"), "jump")
#					Input.action_press("ui_" + move + "_event_player")
#					yield(ProjectSettings.get("Player"), "move")
#					Input.action_release("ui_" + move + "_event_player")
#					i += 1
#			print("STOP ")
#			moved = true
#			moving = false
#			i = 0
##			set_physics_process(false)
##			while ProjectSettings.get("Player").animationPlayer.is_playing():
##				yield(get_tree(), "idle_frame")
##			finish_move()
##			#emit_signal("finished_movement")
##			if get_parent() != null:
##				get_parent().cmd_move_on = false
#		else:
#			if i < movesArray.size() and !moved and !moving:
#				set_physics_process(false)
#				Target.can_interact = true		
#				moving = true
#				Target.can_interact = true
#				for move in movesArray:
#					print(str(i) + " UN PAS " + move)
#					if Target.jumping:
#						yield(Target, "jump")
#					Input.action_press("ui_" + move + "_event")
#					yield(Target, "move")
#					Input.action_release("ui_" + move + "_event")
#					i += 1
#				Target.can_interact = false
#			print("STOP ")
#			moved = true
#			moving = false
#			i = 0
#			while Target.animationPlayer.is_playing():
#				yield(get_tree(), "idle_frame")
#			finish_move()
#			#emit_signal("finished_movement")
#			if get_parent() != null:
#				get_parent().cmd_move_on = false
#	else:
#		i=0
#		moved = true
#		moving = false
#		if get_parent() != null:
#			get_parent().cmd_move_on = false
#		set_physics_process(false)
#		#print("move event finished")
#		finish_move()
#		#emit_signal("finished_movement")


func colliderIsNotPasable(result):
	for r in result:
		if !r.collider.has_node("Pasable"):
			return true
	return false

func colliderIsPlayerTouch(result):
	for r in result:
		if r.collider.has_node("PlayerTouch"):
			return true
	return false

func interact(result, from):
	#print(from)
	for dictionary in result:
		if typeof(dictionary.collider) == TYPE_OBJECT and dictionary.collider.has_node("Interact"):
			dictionary.collider.exec(from)

func interact_at_collide(result):
	#print(from)
	for dictionary in result:
		if typeof(dictionary.collider) == TYPE_OBJECT and dictionary.collider.is_in_group("Evento"):
			dictionary.collider.exec()

func set_can_interact(can):
	can_interact = can

func get_can_interact():
	return can_interact

func set_moving(move):
	moving = move

func get_moving():
	return moving


func set_Target(t):
	Target = t

func get_Target():
	return Target
	
func finish_move():
	if Target == ProjectSettings.get("Player"):
		Target.can_interact = true
		#Target.being_controlled = false
	print("move event finished")
	executing = false
	if !parentEvent.running:
		parentEvent.erase_from_player()
