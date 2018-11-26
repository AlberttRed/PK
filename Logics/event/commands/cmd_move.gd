extends Node

export(NodePath) onready var nodePath
var Target
#Cada posició será una comanda per moure el jugador. Comandes disponibles up, left, right, down, look_up, look_left, look_right, look_down
export(Array, String) var movesArray

var direction = Vector2(0,0)
var startPos = Vector2(0,0)
var moving = false setget set_moving,get_moving
var can_interact = true setget set_can_interact,get_can_interact
var moved = true
const SPEED = 2
const GRID = 32

var Event
var originalEvent
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
	add_user_signal("finished_movement")
	set_physics_process(false)

func _ready():
	pass
	
func run():
	print("move event started")
	if nodePath == null:
		Target = ProjectSettings.get("Player")
	else:
		print(nodePath)
		Target = get_node(nodePath)
	animationPlayer = Target.get_node("AnimationPlayer")
	Target.world = Target.get_world_2d().get_direct_space_state()
	i = 0
	moved = false
#	if(Target == ProjectSettings.get("Player")):
#		Target.can_interact = false
	Target.can_interact = false
	get_parent().cmd_move_on = true
	set_physics_process(true)
	#while !moved:	
	#yield(self, "finished_movement")
#	if(Target == ProjectSettings.get("Player")):
#		Target.can_interact = true
	emit_signal("finished")



func _physics_process(delta):
	if movesArray.size() != 0 and Target != null and !moved:
		#for move in movesArray:
				#if continuous:	
		resultUp = null
		resultDown = null#world.intersect_point(Vector2(0, 0))
		resultLeft = null#world.intersect_point(Vector2(0, 0))
		resultRight = null#world.intersect_point(Vector2(0, 0))
		#Target.world = Target.get_world_2d().get_direct_space_state()
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
					if can_interact:
						interact_at_collide(resultUp)
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
					if can_interact:					
						interact_at_collide(resultDown)
				up = false
				down = true
				left = false
				right = false
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
					if can_interact:				
						interact_at_collide(resultLeft)
				up = false
				down = false
				left = true
				right = false	
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
					if can_interact:
						interact_at_collide(resultRight)
				up = false
				down = false
				left = false
				right = true		
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
					print("move event finished")
					get_parent().cmd_move_on = false
					emit_signal("finished_movement")
					set_physics_process(false)			
	else:						
		moved = true
		#print("move event finished")
		emit_signal("finished_movement")								


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
