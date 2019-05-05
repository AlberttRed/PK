extends KinematicBody2D

export(bool) var Through = false
export(bool) var Transparent = false

var direction = Vector2(0,0)
var startPos = Vector2(0,0)
var moving = false setget set_moving,get_moving
var can_interact = false setget set_can_interact,get_can_interact
#var event = null
var active_events = []
export(Vector2) var inital_position = Vector2(0,0)

var SPEED = 2
var GRID = 32

var world

var sprite
var animationPlayer

var step2 = false
var facing = ""
var continuous = false
var frameCount = 0
var framesStopped = 2
var resultUp
var resultDown
var resultDownJump
var resultLeft 
var resultRight
var trainer
var step = 0
var jumping = false
var surfing = false
var pushing = false
func _init():
	ProjectSettings.set("Player", self)
	add_user_signal("move")
	add_user_signal("step")
	add_user_signal("jump")
	can_interact = true
	
func _ready():
	trainer = get_node("Trainer")
	GAME_DATA.trainer = trainer
	get_node("Sprite").visible = !Transparent
	world = get_world_2d().get_direct_space_state()
	sprite = get_node("Sprite")
	animationPlayer = get_node("AnimationPlayer")
	if get_node("Sprite").frame == 0 or get_node("Sprite").frame == 2:
		facing = "down"
	elif get_node("Sprite").frame == 4 or get_node("Sprite").frame == 6:
		facing = "left"
	elif get_node("Sprite").frame == 8 or get_node("Sprite").frame == 10:
		facing = "right"
	elif get_node("Sprite").frame == 12 or get_node("Sprite").frame == 14:
		facing = "up"
	


func _physics_process(delta):
	if active_events.size() == 0 and !jumping and !surfing and !pushing:
		if GLOBAL.move_is_continuous() or GLOBAL.is_last_move(facing):
			step = 1
		else:
			step = 0
	elif pushing:
		step = 0
	else:
		#print("player in event " + event.get_name())
		step = 1
			
	resultUp = null
	resultDown = null#world.intersect_point(Vector2(0, 0))
	resultLeft = null#world.intersect_point(Vector2(0, 0))
	resultRight = null#world.intersect_point(Vector2(0, 0))
	if !Through and step == 1:
		resultUp = intersect_point(get_position() + Vector2(0, -GRID))
		resultDown = intersect_point(get_position() + Vector2(0, GRID))
		resultLeft = intersect_point(get_position() + Vector2(-GRID, 0))
		resultRight = intersect_point(get_position() + Vector2(GRID, 0))
	if !moving:				
		if ((Input.is_action_pressed("ui_up") and can_interact and active_events.size() == 0)  or Input.is_action_pressed("ui_up_event")) and !GUI.is_visible():	
			facing = "up"			
			if !jumping:
				if step2:
					animationPlayer.play("walk_up_step2")
				else:
					animationPlayer.play("walk_up_step1")
			if resultUp == null or resultUp.empty() or !colliderIsNotPasable(resultUp) or (isSurfingArea(resultUp) and surfing):
				if (!isSurfingArea(intersect_point(get_position() + Vector2(0, -GRID))) and surfing):
					quit_surf()
				moving = true
				direction = Vector2(0, -step)
				startPos = get_position()
				continuous = true
			elif colliderIsPlayerTouch(resultUp) and colliderIsNotPasable(resultUp):
				if can_interact: #and !Through:
					interact_at_collide(resultUp)
			else:
				print("PAM")
			emit_signal("step")
		elif ((Input.is_action_pressed("ui_down") and can_interact and active_events.size() == 0) or Input.is_action_pressed("ui_down_event")) and !GUI.is_visible():
			facing = "down"
			if !jumping:
				if step2:
					animationPlayer.play("walk_down_step2")
				else:
					animationPlayer.play("walk_down_step1")

			if resultDown == null or resultDown.empty() or !colliderIsNotPasable(resultDown) or (isSurfingArea(resultDown) and surfing):
				#print("surfing: " + str(surfing) + " area: " + str(isSurfingArea(world.intersect_point(get_position() + Vector2(-GRID, 0)))))
				if (!isSurfingArea(intersect_point(get_position() + Vector2(0, GRID))) and surfing):
					quit_surf()
				moving = true
				direction = Vector2(0, step)
				startPos = get_position()
				continuous = true
			elif colliderIsPlayerTouch(resultDown) and colliderIsNotPasable(resultDown):
				print("au")
				if can_interact or active_events.size() != 0:
					print("collision")
					interact_at_collide(resultDown)
			emit_signal("step")
		elif ((Input.is_action_pressed("ui_left") and can_interact and active_events.size() == 0) or Input.is_action_pressed("ui_left_event")) and !GUI.is_visible():#!GUI.is_visible():
			facing = "left"
			if !jumping:
				if step2:
					animationPlayer.play("walk_left_step2")
				else:
					animationPlayer.play("walk_left_step1")
			#if !resultLeft == null:
#				for r in resultLeft:
#					print("RESULT LEFT: " + ProjectSettings.get("Actual_Map").area.get_name())#str(r.rid.get_id()))
#			#print("area map: " + str(ProjectSettings.get("Actual_Map").area))
			print("RESULT LEFT: " + str(resultLeft))
			if resultLeft == null or resultLeft.empty() or !colliderIsNotPasable(resultLeft) or (isSurfingArea(resultLeft) and surfing):
				if (!isSurfingArea(intersect_point(get_position() + Vector2(-GRID, 0))) and surfing):
					quit_surf()
				moving = true
				direction = Vector2(-step, 0)
				startPos = get_position()
				continuous = true
				print("OU MAMA")
			elif colliderIsPlayerTouch(resultLeft) and colliderIsNotPasable(resultLeft):
				print("RESULT LEFT: " + str(resultLeft))
				if can_interact:# and !Through:				
					interact_at_collide(resultLeft)
			emit_signal("step")
		elif ((Input.is_action_pressed("ui_right") and can_interact and active_events.size() == 0) or Input.is_action_pressed("ui_right_event")) and !GUI.is_visible():
			facing = "right"
			if !jumping:
				if step2:
					animationPlayer.play("walk_right_step2")
				else:
					animationPlayer.play("walk_right_step1")

			if resultRight == null or resultRight.empty() or !colliderIsNotPasable(resultRight) or (isSurfingArea(resultRight) and surfing):
				print("cap dins")
				if (!isSurfingArea(intersect_point(get_position() + Vector2(GRID, 0))) and surfing):
					quit_surf()
				moving = true
				direction = Vector2(step, 0)
				startPos = get_position()
				continuous = true
			elif colliderIsPlayerTouch(resultRight) and colliderIsNotPasable(resultRight):
				print("AIAI")
				if can_interact:
					interact_at_collide(resultRight)	
			emit_signal("step")
		else:
			continuous = false
			
	else:
		move_and_collide(direction * SPEED)
		if get_position() == (startPos + Vector2(GRID * direction.x, GRID * direction.y)):
			moving = false
			GRID = 32
			step2 = !step2
			emit_signal("move")
			if GLOBAL.move_is_released():
				GLOBAL.release_move()

func _process(delta):
	pass
#	if Input.is_action_pressed("ui_start") and !GUI.is_visible():
#		GUI.show_menu()
	#if (INPUT.ui_start.is_action_just_pressed()) and !GUI.is_visible():
	#	GUI.show_menu()
		
func _input(event):
	if event.is_action_pressed("ui_esc") and !GUI.is_visible():
		for c in get_parent().get_children():
			print(c.get_name())
			for cc in c.get_children():
				print("child: " + cc.get_name())
		
	if event.is_action_pressed("ui_start") and !GUI.is_visible():
		GUI.show_menu()
	
	if event.is_action_pressed("ui_accept") and !GUI.is_visible():	
		print(facing)
		if facing == "up":
			interact(intersect_point(get_position() + Vector2(0, -GRID)), 0)
		elif facing == "left":
			interact(intersect_point(get_position() + Vector2(-GRID, 0)), 8)
		elif facing == "right":
			interact(intersect_point(get_position() + Vector2(GRID, 0)), 4)
		elif facing == "down":
			interact(intersect_point(get_position() + Vector2(0, GRID)), 12)
	
	if event.is_action_pressed("ui_cancel") and !GUI.is_visible():	
		print("Player: " + str(get_parent().get_position()))
		print("sprite: " + str(sprite.get_position()))
		print("Player: " + str(scale))
		print("sprite: " + str(sprite.scale))
#			for N in ProjectSettings.get("Global_World").get_node("CanvasModulate/Eventos_").get_children():
#				print(N.get_name())


func isSurfingArea(result):
	if result != null:
		for r in result:
			if r.collider.is_in_group("surf_area"):
				return true
	return false
		

func colliderIsNotPasable(result):
	for r in result:
		if !r.collider.has_node("Pasable"):
			print(r.collider.get_name() + " is not pasable")
			return true
	print("PASABLE")
	return false
	
func colliderIsPlayerTouch(result):
	for r in result:
		print(r.collider.get_name())
		if r.collider.get_name() != "Area2D_" and r.collider.has_node("PlayerTouch"):
#			if r.collider.is_in_group("surf_area") and surfing:
#				return false
#			else:
			print("true")
			return true
	print("false")		
	return false
	
func interact(result, from):
	
	for dictionary in result:
		print("INTERACT")
		if typeof(dictionary.collider) == TYPE_OBJECT and dictionary.collider.has_node("Interact"):
			if dictionary.collider.is_in_group("NPC"):
				dictionary.collider.get_parent().exec(from)
			elif dictionary.collider.is_in_group("surf_area") and !surfing:
				surf()
			else:
				if dictionary.collider.get_name() == "Area2D":
					dictionary.collider.get_parent().exec(from)
				else:
					dictionary.collider.exec(from)
			
func interact_at_collide(result):
	for dictionary in result:
		print("INTERACT AT COLLIDE")
		if typeof(dictionary.collider) == TYPE_OBJECT and dictionary.collider.is_in_group("Evento") and !dictionary.collider.is_in_group("Boulder"):
			dictionary.collider.eventTarget = self
			#print(dictionary.collider.get_name())
			dictionary.collider.exec()
		elif typeof(dictionary.collider) == TYPE_OBJECT and dictionary.collider.is_in_group("ledge_area"):
			if dictionary.collider.direction == facing:
				jump(dictionary.collider.direction, dictionary.collider.cells_jump)
		elif typeof(dictionary.collider) == TYPE_OBJECT and dictionary.collider.is_in_group("Boulder"):
				print("lmao")
				push(dictionary.collider)
				
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

func look(direction):
	match direction:
		"up":
			get_node("Sprite").frame = 12
		"left":
			get_node("Sprite").frame = 4
		"right":
			get_node("Sprite").frame = 8
		"down":
			get_node("Sprite").frame = 0
			
func jump(direction, cells_jump):
		var original_speed = SPEED
		#var original_grid = GRID
		#var cell = 1
		var jumping_frame = 0
		print("start jump " + direction)
		resultUp = intersect_point(get_position() + Vector2(0, -GRID*int(cells_jump)))
		resultDown = intersect_point(get_position() + Vector2(0, GRID*int(cells_jump)))
		resultLeft = intersect_point(get_position() + Vector2(-GRID*int(cells_jump), 0))
		resultRight = intersect_point(get_position() + Vector2(GRID*int(cells_jump), 0))

		if direction == "up" and (resultUp == null or resultUp.empty() or !colliderIsNotPasable(resultUp)):
			match get_node("Sprite").frame:
				13:
					jumping_frame = 15
				_:
					jumping_frame = 13
		elif direction == "right" and (resultRight == null or resultRight.empty() or !colliderIsNotPasable(resultRight)):
			match get_node("Sprite").frame:
				9:
					jumping_frame = 11
				_:
					jumping_frame = 9
		elif direction == "left" and (resultLeft == null or resultLeft.empty() or !colliderIsNotPasable(resultLeft)):
			match get_node("Sprite").frame:
				5:
					jumping_frame = 7
				_:
					jumping_frame = 5
		if direction == "down" and (resultDown == null or resultDown.empty() or !colliderIsNotPasable(resultDown)):
			match get_node("Sprite").frame:
				1:
					jumping_frame = 3
				_:
					jumping_frame = 1
		Through = true
		jumping = true
		animationPlayer.play("jump")
		SPEED = SPEED/2
		GRID = GRID*cells_jump
		can_interact = false
		GLOBAL.move(direction)
		while animationPlayer.is_playing():
			get_node("Sprite").frame = jumping_frame
			can_interact = false
			yield(get_tree(), "idle_frame")
		look(direction)
		SPEED = original_speed
		#GRID = 32
		can_interact = true
		Through = false
		jumping = false
		emit_signal("jump")
		print("finished jump " + direction)
		
func surf():
	if GLOBAL.CanDoSurf():
		GUI.show_msg("El agua tiene buena pinta... Quieres hacer Surf?", null, null, "", [["SÍ","NO"],true,"Choice2"])
		while (GUI.is_visible()):
			yield(get_tree(),"idle_frame")
		if GLOBAL.get_choice_selected() == "Choice1":
			print("A surfear!")
			can_interact = false
			Through = true
			surfing = true
			GLOBAL.move(facing)
			yield(ProjectSettings.get("Player"), "move")
			get_node("Sprite").texture = GAME_DATA.player_surf_sprite
			can_interact = true
			Through = false

func quit_surf():
	print("quit")
	get_node("Sprite").texture = GAME_DATA.player_default_sprite
	surfing = false
	
func push(object):
	print(facing)
	if !pushing and ProjectSettings.get("Actual_Map").strength_on:
		pushing = true
		var cmd = object.get_parent().get_node("pages/event_page/cmd_strength")
		print("push")
		#var cmd = object.get_parent().get_child(0).get_child(0).get_child(0)
		
		
		match facing:
			"up":
				cmd.direction = Vector2(0, -1)
				cmd.result = object.get_parent().world.intersect_point(object.get_parent().get_position() + Vector2(0, -GRID), 32, [ ], 2147483647, true, true)
			"right":
				cmd.direction = Vector2(1, 0)
				cmd.result = object.get_parent().world.intersect_point(object.get_parent().get_position() + Vector2(GRID, 0), 32, [ ], 2147483647, true, true)
			"left":
				cmd.direction = Vector2(-1, 0)
				cmd.result =  object.get_parent().world.intersect_point(object.get_parent().get_position() + Vector2(-GRID, 0), 32, [ ], 2147483647, true, true)
			"down":
				cmd.direction = Vector2(0, 1)
				cmd.result = object.get_parent().world.intersect_point(object.get_parent().get_position() + Vector2(0, GRID), 32, [ ], 2147483647, true, true)
		cmd.can_move = !colliderIsNotPasable(cmd.result)
		cmd.startPos = object.get_parent().get_position()
		
		cmd.movesArray = [facing]
#		GLOBAL.move_event(object.get_parent(), facing)
		yield(cmd, "moved")
		#while !move.moved:
			#yield(move.run(), "finished_movement")
		print("apa siau")
		pushing = false


func intersect_point(position):
	if weakref(ProjectSettings.get("Actual_Map")).get_ref(): #Comprovem que l'Acual Map s'hagi actualitzat en el cas de canviar de mapa i aixi evitar que doni error
		return world.intersect_point(position, 32, [ProjectSettings.get("Actual_Map").get_area(get_tree())], 2147483647, true, true)
	#return world.intersect_point(position, 32, [], 2147483647, true, true)