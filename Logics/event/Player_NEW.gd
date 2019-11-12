extends Area2D

var tile_size = 32
var step = 1
var can_move = true
var facing = 'right'
var movement = 0
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

# Called when the node enters the scene tree for the first time.
func _init():
	ProjectSettings.set("Player", self)
	
func _process(delta):
	if can_move:
		for dir in moves.keys():
			if Input.is_action_pressed("ui_" + dir):
				move(dir)

func move(dir):
	facing = dir
	$AnimationPlayer.play("walk_" + facing + "_step" + str(step))# + "_prova")
	if get_node(raycasts[dir]).is_colliding():
		print("pum")
		$Sprite.frame = facing_idle[dir]
		movement = position
		$AnimationPlayer.playback_speed = 0.5
	else:
		movement = position + moves[facing] * tile_size
		$AnimationPlayer.playback_speed = 1
	can_move = false
	$MoveTween.interpolate_property(self, "position", position,
                      movement, 0.3,
                      Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$MoveTween.start()
	return true

func _on_MoveTween_tween_completed(object, key):
	can_move = true
	if step == 1:
		step = 2
	else:
		step = 1
	$Sprite.frame = facing_idle[facing]
