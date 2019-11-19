extends Area2D

export(bool) var Through = false

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
var surfing = false
var pushing = false
var in_event = false

var first_input = true
var last_facing

var can_interact = true setget set_can_interact,get_can_interact
var being_controlled = false

var move 

var idles = {8: 'right',
             4: 'left',
             12: 'up',
             0: 'down'}

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
				
var next_step = {13: 15,
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
	facing = idles[$Sprite.frame]
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
	else:
		check_first_step()
	print("position: " + str(position))
	print("movement: " + str(movement))
	$MoveTween.interpolate_property(self, "position", position,
                      movement, step_speed,
                      Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$MoveTween.start()
	return true
	

func jump(cells_jump):
		var original_speed = SPEED

		var jumping_frame = 0
		print("start jump " + facing)
		Through = true
		direction.update()
		
		if !direction.is_colliding():
			jumping_frame = next_step[$Sprite.frame]
		jumping = true
		$an.play("jump")
		SPEED = SPEED/2
		tile_size = tile_size*cells_jump
		can_interact = false
		GLOBAL.move(facing)
		while $AnimationPlayer.is_playing():
			get_node("Sprite").frame = jumping_frame
			can_interact = false
			yield(get_tree(), "idle_frame")
		look(facing)
		SPEED = original_speed
		tile_size = CONST.GRID_SIZE
		can_interact = true
		Through = false
		jumping = false
		emit_signal("jump")
		print("finished jump " + facing)

func check_first_step():
	if first_input and !GLOBAL.is_last_move(last_facing):
		movement = position
		step_speed = 0.15
		$AnimationPlayer.playback_speed = 2
	else:
		movement = position + moves[facing] * tile_size
		step_speed = 0.3
		$AnimationPlayer.playback_speed = 1
		moved = true

func _on_MoveTween_tween_completed(object, key):
	print("CEST FINI")
	
	

	if $AnimationPlayer.is_playing():
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
	if jumping:
		$AnimationPlayer.play("idle_" + facing)
	else:
		if !$AnimationPlayer.is_playing():
			print("animation step: " + str(step))
			$AnimationPlayer.play("walk_" + facing + "_step" + str(step) + "_prova")
			if step == 1:
				step = 2
			else:
				step = 1
				
func quit_surf():
	print("quit")
	get_node("Sprite").texture = GAME_DATA.player_default_sprite
	surfing = false

func update_maparea_exception(area):
	for dir in moves.keys():
		pass#get_node(raycasts[dir]).add_exception(area)
#	$RayCastDown.add_exception(area)
#	$RayCastLeft.add_exception(area)
#	$RayCastRight.add_exception(area)
#	$RayCastUp.add_exception(area)


func look(where):
	$Sprite.frame = facing_idle[where]


func set_can_interact(can):
	print("CAN INTERACT SET: " + str(can))
	can_interact = can
	
func get_can_interact():
	return can_interact
	
func print_pkmn_team():
	for p in get_node("Trainer").get_children():
		p.print_pokemon()
		p.print_moves()
		
func teleport(position):
	set_position(position)
	