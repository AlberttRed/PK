
extends KinematicBody2D

var world

var current_page
var player

export(bool) var Through = false
export(bool) var Transparent = false

export (bool)var Pasable = false
export (Texture)var Imagen = null
export (bool)var Interact = false
export (bool)var DirectionFix = false
export (bool)var PlayerTouch = false
export (bool)var EventTouch = false
const GRID = 32

export (int)var sprite_cols = 1
export (int)var sprite_rows = 1

var enter = false

var isTrainer = has_node("Trainer")
var trainer

var resultUp
var resultDown
var resultLeft 
var resultRight
export(int, "down", "left", "right", "up") var direction = 0

func set_page(page):
	current_page = page
	


func _ready():
	add_to_group(get_parent().get_parent().get_name())
	get_node("Sprite").visible = !Transparent
	world = get_world_2d().get_direct_space_state()
	if Pasable:
		var n = Node2D.new()
		n.set_name("Pasable")
		add_child(n)
	if Imagen != null:
		get_node("Sprite").texture = Imagen
		get_node("Sprite").hframes = sprite_cols
		get_node("Sprite").vframes = sprite_rows
		get_node("Sprite").offset = Vector2(0,4)
		get_node("Sprite").set_position(Vector2(0,-24))
		get_node("Sprite").frame = direction*4
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
	if (get_node("pages").get_child_count() > 0):
		current_page = get_node("pages").get_child(0)
		
func _process(delta):
	pass
    # Destroy every colliding areas
#    var colliding_areas = get_overlapping_areas()
#    for area in colliding_areas:
#        print(area.get_name())

func exec(from = direction):
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
		player.can_interact = false
		current_page.run()
		yield(current_page, "finished")
		if Imagen != null and Imagen.get_width() / 32 > 1 and !DirectionFix:
			get_node("Sprite").frame = direction*4
		player.can_interact = true

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
		exec()
		
func trainerRange():
	pass

