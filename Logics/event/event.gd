extends Area2D

export(bool) var Through = false
export(float) var speed_animation = 1.0
var actual_position

var tile_size = CONST.GRID_SIZE
var step = 1
var step_speed = 0.3
var can_move = true
var facing
var movement = Vector2(0, 0)#0
var direction
var moved = false
var SPEED = 2

var jumping = false
var surfing setget set_surfing,get_surfing
var pushing = false
var running = false setget set_running,get_running

var in_event = false
var collided = false

var first_input = true
var last_facing

var can_interact = true setget set_can_interact,get_can_interact
var being_controlled = false

var move_event 

var trainer

var directions = {8: 'right',
			9: 'right',
			10: 'right',
			11: 'right',
			 4: 'left',
			5: 'left',
			6: 'left',
			7: 'left',
			 12: 'up',
			13: 'up',
			14: 'up',
			15: 'up',
			 0: 'down',
			1: 'down',
			2: 'down',
			3: 'down'}

var facing_idle = {'right': 8,
				 'left': 4,
				 'up': 12,
				 'down': 0}
var moves = {'right': Vector2(1, 0),
			 'left': Vector2(-1, 0),
			 'up': Vector2(0, -1),
			 'down': Vector2(0, 1)}
var raycasts = {'right': 'RayCastRight',
				'left': 'RayCastLeft',
				'up': 'RayCastUp',
				'down': 'RayCastDown'}
				
var next_step = {0:1,
				13: 15,
				 15: 13,
				 11: 9,
				 9: 11,
				 7: 5,
				 5: 7,
				 3: 1,
				 1: 3}

# Called when the node enters the scene tree for the first time.

func _init():
	move_event =  load("res://Logics/event/event_movement.gd").new()
	move_event.set_name("move")
	

func _ready():
	trainer = $Trainer
	facing = get_direction()
	direction = get_node(raycasts[facing])
	actual_position = position

func move(dir):
	moved = false
	collided = false
	direction = get_node(raycasts[dir])
	last_facing = facing
	facing = dir

	check_first_step()
	direction.update()
	walk_animation()
	if !direction.is_SurfingArea() and surfing:
		quit_surf()
	if direction.is_colliding():
		movement = position
		collided = true
		look(facing)
		$AnimationPlayer.playback_speed = 0.5
		first_input = true
		if !direction.interact_at_collide():
			$AudioSystem.play_sound(AUDIO_DATA.COLLISION_SOUND)
		if being_controlled:
			emit_signal("controlled_move")
	else:
		collided = false
	#print("position: " + str(position))
	#print("movement: " + str(movement))
	$MoveTween.interpolate_property(self, "position", position,
					  movement, step_speed/speed_animation,
					  Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$MoveTween.start()
	return true
	
func jump(cells_jump):
		var original_speed = speed_animation#SPEED

		var jumping_frame = 0
		print("start jump " + get_direction())
		Through = true
	#	direction.update()
		
		#if !direction.is_colliding():
		jumping_frame = $Sprite.frame+1
		jumping = true
		speed_animation = speed_animation/1.2
		#$AnimationPlayer.playback_speed = $AnimationPlayer.playback_speed/2.0
		#SPEED = SPEED/2
		tile_size = tile_size#*cells_jump
		can_interact = false
		#GLOBAL.move(facing)
		var moves_to_do = []
		for i in range(cells_jump): # Similar to [1, 2] but does not allocate an array.
			i=i
			moves_to_do.append(get_direction())
		add_child(move_event)
		move_event.add(moves_to_do, self)
		$AnimationPlayer.play("jump")
		while $AnimationPlayer.is_playing():
			get_node("Sprite").frame = jumping_frame
			can_interact = false
			yield(get_tree(), "idle_frame")
		look(get_direction())
		speed_animation = original_speed
		#SPEED = original_speed
		tile_size = CONST.GRID_SIZE
		#yield(move_event, "moved")
		can_interact = true
		Through = false
		jumping = false
		emit_signal("jump")
		remove_child(move_event)
		print("finished jump " + get_direction())
		print(str($Sprite.position))

func check_first_step():
	if first_input and !GLOBAL.is_last_move(last_facing) and !jumping and !being_controlled:
		movement = position
		step_speed = 0.15#float($AnimationPlayer.current_animation_length) / 2.0
		$AnimationPlayer.playback_speed = 2
	else:
		movement = position + moves[facing] * tile_size
		if running:
			step_speed = 0.15# float($AnimationPlayer.current_animation_length) / 2.0
			$AnimationPlayer.playback_speed = 2.0
		else:
			step_speed = 0.3#float($AnimationPlayer.current_animation_length)
			$AnimationPlayer.playback_speed = 1.0
		moved = true

func _on_MoveTween_tween_completed(object, key):
	
	facing = get_direction()
	if $AnimationPlayer.is_playing() and !jumping and !collided:
		#yield(get_tree(), "idle_frame")
		$AnimationPlayer.stop()
	elif collided and !jumping:
		while $AnimationPlayer.is_playing():
			yield(get_tree(), "idle_frame")
	$Sprite.frame = facing_idle[facing]
	if being_controlled and moved:
		emit_signal("controlled_move")
	if GLOBAL.move_is_released():
		first_input = true
	else:
		first_input = false 
	can_move = true
	emit_signal("move")
	direction.is_encounter_area()
	actual_position = position

func walk_animation():
	if running:
		$Sprite.texture = GAME_DATA.player_run_sprite
		step_speed = 0.15
	if !$AnimationPlayer.is_playing() and !jumping:
		#print("animation step: " + str(step))
		$AnimationPlayer.play("walk_" + facing + "_step" + str(step) + "_prova")
		if step == 1:
			step = 2
		else:
			step = 1
				
func push(object):
	print(get_direction() + " " + str(pushing) + " " + str(GAME_DATA.ACTUAL_MAP.strength_on))
	if !pushing and GAME_DATA.ACTUAL_MAP.strength_on:
		pushing = true
		#var cmd = object.get_node("pages/event_page/cmd_strength")
		print("push")
		$AnimationPlayer.stop()
		object.speed_animation = 0.5
		object.move_event.add([get_direction()], object)
		
		pushing = false
		print("apa siau")

func surf():
	if GLOBAL.CanDoSurf():
		GUI.show_msg("El agua tiene buena pinta... Quieres hacer Surf?", null, null, "", [["SÍ","NO"],true,"Choice2"])
		while (GUI.is_visible()):
			yield(get_tree(),"idle_frame")
		if GLOBAL.get_choice_selected() == "Choice1":
			print("A surfear!")
			can_interact = false
			#Through = true
			set_surfing(true)
			#GLOBAL.move(facing)
			move_event.add([get_direction()], self)
			yield(self, "move")
			
			$Sprite.texture = GAME_DATA.player_surf_sprite
			can_interact = true
			Through = false

func quit_surf():
	print("quit")
	$Sprite.texture = GAME_DATA.player_default_sprite
	set_surfing(false)


func look(where):
	$Sprite.frame = facing_idle[where]


func set_can_interact(can):
	print("CAN INTERACT SET: " + str(can))
	can_interact = can
	
func get_can_interact():
	return can_interact
	
func set_surfing(surf):
	print("SURFING SET: " + str(surf))
	surfing = surf
	
func get_surfing():
	return surfing
	
func set_running(run):

	if !run:
		$Sprite.texture = GAME_DATA.player_default_sprite
		step_speed = 0.3#float($AnimationPlayer.current_animation_length)
		
	running = run
	
func get_running():
	return running
	
	
func print_pkmn_team():
	for p in get_node("Trainer").get_children():
		p.print_pokemon()
		p.print_moves()
		
func teleport(position):
	set_position(position)
	
func get_direction():
	return directions[$Sprite.frame]
	
func init_move():
	add_child(move_event)
	
func release_move():
	remove_child(move_event)
