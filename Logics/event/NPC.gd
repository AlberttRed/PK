
extends KinematicBody2D

var world

var current_page
var player
var sprite
var animationPlayer

var startPos = Vector2(0,0)

export(bool) var Through = false
export(bool) var Transparent = false


export (bool)var Pasable = false
export (Texture)var Imagen = null
export (bool)var Interact = false
export (bool)var DirectionFix = false
export (bool)var PlayerTouch = false
export (bool)var EventTouch = false
export (bool)var AutoRun = false
export (bool)var BlockPlayerAtEnd = false
export (bool)var deleteAtEnd = false

export (Vector2)var OffsetSprite = Vector2(0,4)

var direction = Vector2(0,0)
var moving = false 
var can_interact = false 

var SPEED = 2
var GRID = 32

var running = false
var eventTarget = null
var active_events = []


var step2 = false
var facing = ""
var continuous = false
var frameCount = 0
var framesStopped = 2
var step = 0
var jumping = false
var surfing = false
var pushing = false

export (int)var sprite_cols = 1
export (int)var sprite_rows = 1

var enter = false

var isTrainer = has_node("Trainer")
var trainer

var resultUp
var resultDown
var resultLeft 
var resultRight
var resultDownJump
export(int, "down", "left", "right", "up") var look = 0

func set_page(page):
	current_page = page
	
func _init():
	add_user_signal("event_finished")
	add_user_signal("move")
	add_user_signal("step")
	add_user_signal("jump")

func _ready():
	add_to_group(get_parent().get_parent().get_name())
	add_to_group("NPC")
	get_node("Sprite").visible = !Transparent
	world = get_world_2d().get_direct_space_state()
	animationPlayer = get_node("AnimationPlayer")
	if Pasable:
		makePasable()
	if Imagen != null:
		get_node("Sprite").texture = Imagen
		get_node("Sprite").hframes = sprite_cols
		get_node("Sprite").vframes = sprite_rows
		get_node("Sprite").offset = OffsetSprite
		get_node("Sprite").set_position(Vector2(0,-24))#-24
		get_node("Sprite").frame = look*4
		#if Imagen.get_width() / 32 > 1:
			#get_node("Sprite").hframes = (Imagen.get_width() / 32)/2
			#get_node("Sprite").vframes = (Imagen.get_width() / 32)/2
			#get_node("Sprite").offset = Vector2(0,-(Imagen.get_width() / 32)*2)
	if Interact:
		var n = Node2D.new()
		n.set_name("Interact")
		get_node("Area2D").add_child(n)
	elif PlayerTouch:
		#get_node("Area2D").connect("area_entered",get_node("Area2D"),"_execPlayerTouch")
		var n = Node2D.new()
		n.set_name("PlayerTouch")
		get_node("Area2D").add_child(n)
	elif EventTouch:
		#get_node("Area2D").connect("area_entered",get_node("Area2D"),"_execEventTouch")
		var n = Node2D.new()
		n.set_name("EventTouch")
		get_node("Area2D").add_child(n)
		
	if has_node("Trainer"):
		isTrainer = true
		trainer = get_node("Trainer")
		
	player=ProjectSettings.get("Player")
	set_parent_event(get_node("pages"))
	
	if (get_node("pages").get_child_count() > 0):
		current_page = get_node("pages").get_child(0)
		
func _process(delta):
	if AutoRun:
		AutoRun = false
		exec()
    # Destroy every colliding areas
#    var colliding_areas = get_overlapping_areas()
#    for area in colliding_areas:
#        print(area.get_name())

func exec(from = look):
	if !running:
#		if eventTarget == ProjectSettings.get("Player"):
#			ProjectSettings.get("Player").active_events.push_back(self)
		GLOBAL.running_events.push_back(self)
		running = true
		while player.get_moving():
			yield(get_tree(), "idle_frame")
		if (current_page == null):
			return
		if Imagen != null and Imagen.get_width() / 32 > 1 and !DirectionFix:
			#if from == "up":
				get_node("Sprite").frame = from
			#elif from == "down":
				#get_node("Sprite").frame = 12
			#elif from == "left":
				#get_node("Sprite").frame = 8
			#elif from == "right":
				#get_node("Sprite").frame = 4
		if isTrainer and !trainer.is_defeated:
			GUI.show_msg(trainer.before_battle_message)
			yield(GUI.msg, "finished")
			GUI.start_battle(trainer.double_battle, GAME_DATA.trainer, trainer)#, null, trainer)
		else:
			#player.can_interact = false
			current_page.run()
			#yield(current_page, "finished_page")
			if Imagen != null and Imagen.get_width() / 32 > 1 and !DirectionFix:
				get_node("Sprite").frame = look*4
			#player.set_can_interact(!BlockPlayerAtEnd)
			#player.can_interact = true
		
		if ProjectSettings.get("Player").active_events.has(self) and !current_page.is_executing():
			ProjectSettings.get("Player").active_events.erase(self)
		GLOBAL.running_events.erase(self)
		running = false
		if deleteAtEnd:
			remove()
	else:
		print("event " + get_name() + " is already running!")
	print("event " + get_name() + " finished")
	emit_signal("event_finished")

func exec_this_page(page):
	if (page<0 or page>=get_node("pages").get_child_count()):
		return
	var p = get_node("pages").get_child(page)
	player.can_interact = false
	p.run()
	yield(p, "finished")
	player.can_interact = true

func _execEventTouch(target):
	if target.is_in_group("Evento"):
		exec()
	
func _execPlayerTouch(target):
	if target.is_in_group("Player"):
		print("PLAYER TOUCH")
		eventTarget = target.get_parent()
		exec()
		
func trainerRange():
	pass
	
func remove():
	if is_inside_tree():
    	queue_free()
	else:
    	call_deferred("free")

func makePasable():
	var n = Node2D.new()
	n.set_name("Pasable")
	get_node("Area2D").add_child(n)

func erase_from_player():
	if ProjectSettings.get("Player").active_events.has(self):
		ProjectSettings.get("Player").active_events.erase(self)
		
func set_parent_event(pages):
	if pages.get_child_count() > 0:
		for p in pages.get_children():
			set_parent_event(p)
			
	if pages.is_in_group("CMD") or pages.is_in_group("PAGE"):
		pages.parentEvent = self
	


func _physics_process(delta):
#	if !jumping and !surfing and !pushing:
#		if GLOBAL.move_is_continuous():
#			step = 1
#		else:
#			step = 0
#	elif pushing:
#		step = 0
#	else:
#		#print("player in event " + event.get_name())
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
		if (can_interact and active_events.size() == 0 and Input.is_action_pressed("ui_up_event")): #and !GUI.is_visible():	
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
		elif (can_interact and active_events.size() == 0 and Input.is_action_pressed("ui_down_event")):# and !GUI.is_visible():
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
				#print("au")
				if can_interact or active_events.size() != 0:
					#print("collision")
					interact_at_collide(resultDown)
			emit_signal("step")
		elif (can_interact and active_events.size() == 0 and Input.is_action_pressed("ui_left_event")):# and !GUI.is_visible():#!GUI.is_visible():
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
			#print("RESULT LEFT: " + str(resultLeft))
			if resultLeft == null or resultLeft.empty() or !colliderIsNotPasable(resultLeft) or (isSurfingArea(resultLeft) and surfing):
				if (!isSurfingArea(intersect_point(get_position() + Vector2(-GRID, 0))) and surfing):
					quit_surf()
				moving = true
				direction = Vector2(-step, 0)
				startPos = get_position()
				continuous = true
				#print("OU MAMA")
			elif colliderIsPlayerTouch(resultLeft) and colliderIsNotPasable(resultLeft):
				#print("RESULT LEFT: " + str(resultLeft))
				if can_interact:# and !Through:				
					interact_at_collide(resultLeft)
			emit_signal("step")
		elif (can_interact and active_events.size() == 0 and Input.is_action_pressed("ui_right_event")):# and !GUI.is_visible():
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
#			Input.action_release("ui_right_event")
#			Input.action_release("ui_left_event")
#			Input.action_release("ui_up_event")
#			Input.action_release("ui_down_event")
#			if active_events.size() > 0:
			emit_signal("move")
			print("STEP COMPLETED")
			if GLOBAL.move_is_released():
				GLOBAL.release_move()
				
func isSurfingArea(result):
	if result != null:
		for r in result:
			if r.collider.is_in_group("surf_area"):
				return true
	return false
		
func colliderIsNotPasable(result):
	for r in result:
		if !r.collider.has_node("Pasable"):
			#print(r.collider.get_name() + " is not pasable")
			return true
	print("PASABLE")
	return false
	
func colliderIsPlayerTouch(result):
	for r in result:
		#print(r.collider.get_name())
		if r.collider.get_name() != "Area2D_" and r.collider.has_node("PlayerTouch"):
#			if r.collider.is_in_group("surf_area") and surfing:
#				return false
#			else:
	#		print("true")
			return true
	#print("false")		
	return false
	
func quit_surf():
	print("quit")
	get_node("Sprite").texture = GAME_DATA.player_default_sprite
	surfing = false
	
func intersect_point(position):
	if weakref(ProjectSettings.get("Actual_Map")).get_ref(): #Comprovem que l'Acual Map s'hagi actualitzat en el cas de canviar de mapa i aixi evitar que doni error
		return world.intersect_point(position, 32, [ProjectSettings.get("Actual_Map").get_area(get_tree())], 2147483647, true, true)
	#return world.intersect_point(position, 32, [], 2147483647, true, true)

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

		
func interact_at_collide(result):
	for dictionary in result:
		print("INTERACT AT COLLIDE")
		if typeof(dictionary.collider) == TYPE_OBJECT and dictionary.collider.is_in_group("Evento") and !dictionary.collider.is_in_group("Boulder"):
			if dictionary.collider.is_in_group("NPC"):
#				if !dictionary.collider.get_parent().running:
#					dictionary.collider.get_parent().eventTarget = self
#					dictionary.collider.get_parent().exec()
					EVENTS.add_event(dictionary.collider.get_parent(), self)
			else:
#				if !dictionary.collider.running:
#					dictionary.collider.eventTarget = self
#				#print(dictionary.collider.get_name())
#					dictionary.collider.exec()
					EVENTS.add_event(dictionary.collider, self)
		elif typeof(dictionary.collider) == TYPE_OBJECT and dictionary.collider.is_in_group("ledge_area"):
			if dictionary.collider.direction == facing:
				jump(dictionary.collider.direction, dictionary.collider.cells_jump)
		elif typeof(dictionary.collider) == TYPE_OBJECT and dictionary.collider.is_in_group("Boulder"):
				print("lmao")
				push(dictionary.collider)
				