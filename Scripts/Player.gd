extends KinematicBody2D

export(bool) var Through = false
export(bool) var Transparent = false

var direction = Vector2(0,0)
var startPos = Vector2(0,0)
var moving = false setget set_moving,get_moving
var can_interact = true setget set_can_interact,get_can_interact

export(Vector2) var inital_position = Vector2(0,0)

const SPEED = 2
const GRID = 32

var world

var sprite
var animationPlayer

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
var trainer

func _init():
	ProjectSettings.set("Player", self)
	add_user_signal("move")
	
func _ready():
	trainer = get_node("Trainer")
	GAME_DATA.trainer = trainer
	get_node("Sprite").visible = !Transparent
	world = get_world_2d().get_direct_space_state()
	sprite = get_node("Sprite")
	animationPlayer = get_node("AnimationPlayer")
	if get_node("Sprite").frame == 0 or get_node("Sprite").frame == 2:
		down = true
	elif get_node("Sprite").frame == 4 or get_node("Sprite").frame == 6:
		left = true
	elif get_node("Sprite").frame == 8 or get_node("Sprite").frame == 10:
		right = true
	elif get_node("Sprite").frame == 12 or get_node("Sprite").frame == 14:
		up = true
	


func _physics_process(delta):
	#if !moving:	
	
	if continuous:	
		resultUp = null
		resultDown = null#world.intersect_point(Vector2(0, 0))
		resultLeft = null#world.intersect_point(Vector2(0, 0))
		resultRight = null#world.intersect_point(Vector2(0, 0))
		if !Through:
			resultUp = world.intersect_point(get_position() + Vector2(0, -GRID))
			resultDown = world.intersect_point(get_position() + Vector2(0, GRID))
			resultLeft = world.intersect_point(get_position() + Vector2(-GRID, 0))
			resultRight = world.intersect_point(get_position() + Vector2(GRID, 0))
		if !moving:				
			if Input.is_action_pressed("ui_up") and can_interact and !GUI.is_visible():#!GUI.is_visible():
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
					startPos = get_position()
					continuous = true
				elif colliderIsPlayerTouch(resultUp) and colliderIsNotPasable(resultUp):
					#if can_interact:
						interact_at_collide(resultUp)
			elif Input.is_action_pressed("ui_down") and can_interact and !GUI.is_visible():#!GUI.is_visible():
				if step2:
					animationPlayer.play("walk_down_step2")
				else:
					animationPlayer.play("walk_down_step1")
	
				if resultDown == null or resultDown.empty() or !colliderIsNotPasable(resultDown):#resultDown[resultDown.size()-1].collider.has_node("Pasable"):
					moving = true
					direction = Vector2(0, 1)
					startPos = get_position()
					continuous = true
				elif colliderIsPlayerTouch(resultDown) and colliderIsNotPasable(resultDown):
					if can_interact:					
						interact_at_collide(resultDown)
				up = false
				down = true
				left = false
				right = false
			elif Input.is_action_pressed("ui_left") and can_interact and !GUI.is_visible():#!GUI.is_visible():
				if step2:
					animationPlayer.play("walk_left_step2")
				else:
					animationPlayer.play("walk_left_step1")
	
				if resultLeft == null or resultLeft.empty() or !colliderIsNotPasable(resultLeft):#resultLeft[resultLeft.size()-1].collider.has_node("Pasable"):
					moving = true
					direction = Vector2(-1, 0)
					startPos = get_position()
					continuous = true
				elif colliderIsPlayerTouch(resultLeft) and colliderIsNotPasable(resultLeft):
					if can_interact:				
						interact_at_collide(resultLeft)
				up = false
				down = false
				left = true
				right = false	
			elif Input.is_action_pressed("ui_right") and can_interact and !GUI.is_visible():#!GUI.is_visible():
				if step2:
					animationPlayer.play("walk_right_step2")
				else:
					animationPlayer.play("walk_right_step1")
	
				if resultRight == null or resultRight.empty() or !colliderIsNotPasable(resultRight):#resultRight[resultRight.size()-1].collider.has_node("Pasable"):
					moving = true
					direction = Vector2(1, 0)
					startPos = get_position()
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
			move_and_collide(direction * SPEED)
			if get_position() == (startPos + Vector2(GRID * direction.x, GRID * direction.y)):
				moving = false
				#print(get_position())
				step2 = !step2
				emit_signal("move")

func _process(delta):
	pass
#	if Input.is_action_pressed("ui_start") and !GUI.is_visible():
#		GUI.show_menu()
	#if (INPUT.ui_start.is_action_just_pressed()) and !GUI.is_visible():
	#	GUI.show_menu()
		
func _input(event):
	resultUp = null
	resultDown = null
	resultLeft = null
	resultRight = null
		
	resultUp = world.intersect_point(get_position() + Vector2(0, -GRID))
	resultDown = world.intersect_point(get_position() + Vector2(0, GRID))
	resultLeft = world.intersect_point(get_position() + Vector2(-GRID, 0))
	resultRight = world.intersect_point(get_position() + Vector2(GRID, 0))
	if event.is_action_pressed("ui_esc") and !GUI.is_visible():
		for c in get_parent().get_children():
			print(c.get_name())
			for cc in c.get_children():
				print("child: " + cc.get_name())
		
	if event.is_action_pressed("ui_start") and !GUI.is_visible():
		GUI.show_menu()
		
	if !moving:						
		if event.is_action_pressed("ui_right") and can_interact and !right and !GUI.is_visible():#!GUI.is_visible() and !right:
			up = false
			down = false
			left = false
			right = true
			if step2:
				animationPlayer.play("walk_right_step2", -1, 2.0)
			else:
				animationPlayer.play("walk_right_step1", -1, 2.0)
				
			while animationPlayer.is_playing():
					yield(get_tree(), "idle_frame")

		elif event.is_action_pressed("ui_left") and can_interact and !left and !GUI.is_visible():#!GUI.is_visible() and !left:
			up = false
			down = false
			left = true
			right = false	
			if step2:
				animationPlayer.play("walk_left_step2", -1, 2.0)
			else:
				animationPlayer.play("walk_left_step1", -1, 2.0)
				
			while animationPlayer.is_playing():
					yield(get_tree(), "idle_frame")
					
		elif event.is_action_pressed("ui_down") and can_interact and !down and !GUI.is_visible():#!GUI.is_visible() and !down:
			up = false
			down = true
			left = false
			right = false	
			if step2:
				animationPlayer.play("walk_down_step2", -1, 2.0)
			else:
				animationPlayer.play("walk_down_step1", -1, 2.0)
			
			while animationPlayer.is_playing():
					yield(get_tree(), "idle_frame")
					
		elif event.is_action_pressed("ui_up") and can_interact and !up and !GUI.is_visible():#!GUI.is_visible() and !up:
			up = true
			down = false
			left = false
			right = false	
			if step2:
				animationPlayer.play("walk_up_step2", -1, 2.0)
			else:
				animationPlayer.play("walk_up_step1", -1, 2.0)

			while animationPlayer.is_playing():
				yield(get_tree(), "idle_frame")
		continuous = true
	else:
		if get_position() == (startPos + Vector2(GRID * direction.x, GRID * direction.y)):
			moving = false
			#print(get_position())
			step2 = !step2
			continuous = false
	
	if event.is_action_pressed("ui_accept") and !GUI.is_visible():	
		if up:
			interact(resultUp, 0)
		elif left:
			interact(resultLeft, 8)
		elif right:
			interact(resultRight, 4)
		elif down:
			interact(resultDown, 12)
	
	if event.is_action_pressed("ui_cancel") and !GUI.is_visible():	
			for N in ProjectSettings.get("Global_World").get_node("CanvasModulate/Eventos_").get_children():
				print(N.get_name())
	
	
#	if (event.is_action_pressed("ui_start")) and !GUI.is_visible():#Input.is_action_pressed("ui_cancel"):#(INPUT.ui_cancel.is_action_just_pressed()):
#		GUI.show_menu()
#
#func _input(event):
#	if event.is_action_pressed("ui_start"):
#		GUI.show_menu()
#	if event.is_action_pressed("ui_cancel"):
#		print("Previous: " + ProjectSettings.get("Previous_Map").get_name())
#		#print(get_tree().get_root().get_node("World").get_name())
#		for i in get_tree().get_root().get_node("World").get_children():
#				print(i.get_name())
#		#print(ProjectSettings.get("Actual_Map").get_children())
#		if up:
#			interact(resultUp, "up")
#			#GUI.show_msg("¡Hola a todos! ¡Bienvenidos al mundo de POKÉMON! ¡Me llamo OAK! ¡Pero la gente me llama el PROFESOR POKÉMON!")
#		elif left:
#			interact(resultLeft, "left")
#		elif right:
#			interact(resultRight, "right")
#		elif down:
#			interact(resultDown, "down")
#

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
			if dictionary.collider.is_in_group("NPC"):
				dictionary.collider.get_parent().exec(from)
			else:
				dictionary.collider.exec(from)
			
func interact_at_collide(result):
	for dictionary in result:
		if typeof(dictionary.collider) == TYPE_OBJECT and dictionary.collider.is_in_group("Evento"):
			print(dictionary.collider.get_name())
			dictionary.collider.exec()
			
func set_can_interact(can):
	can_interact = can

func get_can_interact():
	return can_interact

func set_moving(move):
	moving = move

func get_moving():
	return moving

func _on_Erin_body_entered( body ):
	print("hola")
	
func teleport(position):
	set_position(position)
	
func set_initial_position(pos):
	set_position(inital_position)
