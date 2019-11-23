extends Area2D

export(bool) var Through = false
export(float) var speed_animation = 1.0

var tile_size = CONST.GRID_SIZE
var step = 1
var step_speed = 0.3
var can_move = true
var facing
var movement = 0
var direction
var moved = false
var SPEED = 2

var jumping = false
var surfing setget set_surfing,get_surfing
var pushing = false
var in_event = false

var first_input = true
var last_facing

var can_interact = true setget set_can_interact,get_can_interact
var being_controlled = false

var move 

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
	move =  load("res://Logics/event/event_movement.gd").new()
	move.set_name("move")
	add_child(move)

func _ready():
	trainer = $Trainer
	facing = get_direction()
	direction = get_node(raycasts[facing])

func move(dir):
	moved = false
	direction = get_node(raycasts[dir])
	last_facing = facing
	facing = dir
	direction.update()
	walk_animation()
	if !direction.is_SurfingArea() and surfing:
		quit_surf()
	if direction.is_colliding():
		movement = position
		$AnimationPlayer.playback_speed = 0.5
		first_input = true
		direction.interact_at_collide()
		if being_controlled:
			emit_signal("move")
	else:
		check_first_step()
	print("position: " + str(position))
	print("movement: " + str(movement))
	$MoveTween.interpolate_property(self, "position", position,
                      movement, step_speed/speed_animation,
                      Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$MoveTween.start()
	return true
	
func jump(cells_jump):
		var original_speed = SPEED

		var jumping_frame = 0
		print("start jump " + get_direction())
		Through = true
		direction.update()
		
		#if !direction.is_colliding():
		jumping_frame = $Sprite.frame+1
		jumping = true
	
		SPEED = SPEED/2
		tile_size = tile_size#*cells_jump
		can_interact = false
		#GLOBAL.move(facing)
		var moves = []
		for i in range(cells_jump): # Similar to [1, 2] but does not allocate an array.
			moves.append(get_direction())
		move.add(moves, self)
		$AnimationPlayer.play("jump")
		while $AnimationPlayer.is_playing():
			get_node("Sprite").frame = jumping_frame
			can_interact = false
			yield(get_tree(), "idle_frame")
		look(get_direction())
		SPEED = original_speed
		tile_size = CONST.GRID_SIZE
		can_interact = true
		Through = false
		jumping = false
		emit_signal("jump")
		print("finished jump " + get_direction())
		print(str($Sprite.position))

func check_first_step():
	if first_input and !GLOBAL.is_last_move(last_facing) and !jumping and !being_controlled:
		movement = position
		step_speed = 0.15
		$AnimationPlayer.playback_speed = 2
	else:
		movement = position + moves[facing] * tile_size
		step_speed = 0.3
		$AnimationPlayer.playback_speed = 1.0
		moved = true

func _on_MoveTween_tween_completed(object, key):
	print("CEST FINI: " + str($Sprite.frame))
	facing = get_direction()
	if $AnimationPlayer.is_playing() and !jumping:
		#yield(get_tree(), "idle_frame")
		$AnimationPlayer.stop()
	$Sprite.frame = facing_idle[facing]
	if being_controlled and moved:
		emit_signal("move")
	if GLOBAL.move_is_released():
		first_input = true
	else:
		first_input = false 
	can_move = true

func walk_animation():
	if !$AnimationPlayer.is_playing() and !jumping:
		print("animation step: " + str(step))
		$AnimationPlayer.play("walk_" + facing + "_step" + str(step) + "_prova")
		if step == 1:
			step = 2
		else:
			step = 1
				
func push(object):
	print(get_direction() + " " + str(pushing) + " " + str(ProjectSettings.get("Actual_Map").strength_on))
	if !pushing and ProjectSettings.get("Actual_Map").strength_on:
		pushing = true
		var cmd = object.get_node("pages/event_page/cmd_strength")
		print("push")
		$AnimationPlayer.stop()
		object.speed_animation = 0.5
		object.move.add([get_direction()], object)
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
			move.add([get_direction()], self)
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
	
func print_pkmn_team():
	for p in get_node("Trainer").get_children():
		p.print_pokemon()
		p.print_moves()
		
func teleport(position):
	set_position(position)
	
func get_direction():
	return directions[$Sprite.frame]
	