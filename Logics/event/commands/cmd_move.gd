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
	set_physics_process(true)
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
	if get_parent() != null:
		get_parent().cmd_move_on = true
	set_physics_process(true)
	print("dw")
	#emit_signal("finished")

func _physics_process(delta):
	if movesArray.size() != 0 and Target != null and !moved:
		if Target == ProjectSettings.get("Player"):
			if i < movesArray.size() and !moved and !moving:
				moving = true
				for move in movesArray:
					print(str(i) + " UN PAS " + move)
					if ProjectSettings.get("Player").jumping:
						yield(ProjectSettings.get("Player"), "jump")
					set_physics_process(false)
					Input.action_press("ui_" + move + "_event")
					yield(ProjectSettings.get("Player"), "move")
					Input.action_release("ui_" + move + "_event")
					i += 1
			print("STOP ")
			moved = true
			moving = false
			i = 0
			set_physics_process(false)
			while ProjectSettings.get("Player").animationPlayer.is_playing():
				yield(get_tree(), "idle_frame")
			finish_move()
			#emit_signal("finished_movement")
			if get_parent() != null:
				get_parent().cmd_move_on = false
		else:
			resultUp = null
			resultDown = null
			resultLeft = null
			resultRight = null

			if !Target.Through:
				resultUp = Target.world.intersect_point(Target.get_position() + Vector2(0, -GRID))
				resultDown = Target.world.intersect_point(Target.get_position() + Vector2(0, GRID))
				resultLeft = Target.world.intersect_point(Target.get_position() + Vector2(-GRID, 0))
				resultRight = Target.world.intersect_point(Target.get_position() + Vector2(GRID, 0))
			if !moving and i < movesArray.size():
				if movesArray[i] == "up":# and can_interact and !GUI.is_visible():#!GUI.is_visible():
					i += 1
					up = true
					down = false
					left = false
					right = false
					if step2:
						animationPlayer.play("walk_up_step2")
					else:
						animationPlayer.play("walk_up_step1")
					if resultUp == null or resultUp.empty() or !colliderIsNotPasable(resultUp):# resultUp[resultUp.size()-1].collider.has_node("Pasable"):
						moving = true
						direction = Vector2(0, -1)
						startPos = Target.get_position()
						continuous = true
					elif colliderIsPlayerTouch(resultUp) and colliderIsNotPasable(resultUp):
		#					if can_interact:
							interact_at_collide(resultUp)
					emit_signal("step")
				elif movesArray[i] == "down":# and can_interact and !GUI.is_visible():#!GUI.is_visible():
					i += 1
					if step2:
						Target.get_node("AnimationPlayer").play("walk_down_step2")
					else:
						Target.get_node("AnimationPlayer").play("walk_down_step1")

					if resultDown == null or resultDown.empty() or !colliderIsNotPasable(resultDown):#resultDown[resultDown.size()-1].collider.has_node("Pasable"):
						moving = true
						direction = Vector2(0, 1)
						startPos = Target.get_position()
						continuous = true
					elif colliderIsPlayerTouch(resultDown) and colliderIsNotPasable(resultDown):
		#					if can_interact:
							interact_at_collide(resultDown)
					up = false
					down = true
					left = false
					right = false
					emit_signal("step")
				elif movesArray[i] == "left":# and can_interact and !GUI.is_visible():#!GUI.is_visible():
					i += 1
					if step2:
						animationPlayer.play("walk_left_step2")
					else:
						animationPlayer.play("walk_left_step1")

					if resultLeft == null or resultLeft.empty() or !colliderIsNotPasable(resultLeft):#resultLeft[resultLeft.size()-1].collider.has_node("Pasable"):
						moving = true
						direction = Vector2(-1, 0)
						startPos = Target.get_position()
						continuous = true
					elif colliderIsPlayerTouch(resultLeft) and colliderIsNotPasable(resultLeft):
		#					if can_interact:
							interact_at_collide(resultLeft)
					up = false
					down = false
					left = true
					right = false
					emit_signal("step")
				elif movesArray[i] == "right":# and can_interact and !GUI.is_visible():#!GUI.is_visible():
					i += 1
					if step2:
						animationPlayer.play("walk_right_step2")
					else:
						animationPlayer.play("walk_right_step1")
					if resultRight == null or resultRight.empty() or !colliderIsNotPasable(resultRight):#resultRight[resultRight.size()-1].collider.has_node("Pasable"):
						moving = true
						direction = Vector2(1, 0)
						startPos = Target.get_position()
						continuous = true
					elif colliderIsPlayerTouch(resultRight) and colliderIsNotPasable(resultRight):
		#					if can_interact:
							interact_at_collide(resultRight)
					up = false
					down = false
					left = false
					right = true
					emit_signal("step")
				else:
					continuous = false
			else:
				Target.move_and_collide(direction * SPEED)
				if Target.get_position() == (startPos + Vector2(GRID * direction.x, GRID * direction.y)):
					moving = false
					#print(get_position())
					step2 = !step2
					if i >= movesArray.size():
						moved = true
						finish_move()
						if get_parent() != null:
							get_parent().cmd_move_on = false
						#emit_signal("finished_movement")
						set_physics_process(false)
	else:
		i=0
		moved = true
		if get_parent() != null:
			get_parent().cmd_move_on = false
		set_physics_process(false)
		#print("move event finished")
		finish_move()
		#emit_signal("finished_movement")


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
