
extends Area2D

var world

var current_page
var player
export (bool)var Pasable = false
export (Texture)var Imagen = null
export (bool)var Interact = false
export (bool)var DirectionFix = false
export (bool)var PlayerTouch = false
export (bool)var EventTouch = false
export (bool)var AutoRun = false
export (bool)var BlockPlayerAtEnd = false
var eventTarget = null

const GRID = 32
var running = false

export (bool)var deleteAtEnd = false
export (int)var sprite_cols = 1
export (int)var sprite_rows = 1
export (Vector2)var OffsetSprite = Vector2(0,4)
var enter = false

var resultUp
var resultDown
var resultLeft 
var resultRight
var initialFrame

var teleport = false

func set_page(page):
	current_page = page


func _ready():
	add_to_group(get_parent().get_parent().get_name())
	if Pasable:
		var n = Node2D.new()
		n.set_name("Pasable")
		add_child(n)
	if Imagen != null:
		initialFrame = get_node("Sprite").frame
		get_node("Sprite").texture = Imagen
		get_node("Sprite").hframes = sprite_cols
		get_node("Sprite").vframes = sprite_rows
		get_node("Sprite").offset = OffsetSprite
		get_node("Sprite").set_position(Vector2(0,-24))
		#if Imagen.get_width() / 32 > 1:
			#get_node("Sprite").hframes = (Imagen.get_width() / 32)/2
			#get_node("Sprite").vframes = (Imagen.get_width() / 32)/2
			#get_node("Sprite").offset = Vector2(0,-(Imagen.get_width() / 32)*2)
	if Interact:
		var n = Node2D.new()
		n.set_name("Interact")
		add_child(n)
	elif PlayerTouch:
		connect("area_entered",self,"_execPlayerTouch")
		var n = Node2D.new()
		n.set_name("PlayerTouch")
		add_child(n)
	elif EventTouch:
		connect("area_entered",self,"_execEventTouch")
		var n = Node2D.new()
		n.set_name("EventTouch")
		add_child(n)
		
	player=ProjectSettings.get("Player")
	if (get_node("pages").get_child_count() > 0):
		print("PAGES IN")
		current_page = return_current_page(get_node("pages").get_child(0))
		
func _process(delta):
	if AutoRun:
		AutoRun = false
		exec()
    # Destroy every colliding areas
#    var colliding_areas = get_overlapping_areas()
#    for area in colliding_areas:
#        print(area.get_name())

func exec(from = initialFrame):
	print("event " + get_name() + " started")
	if !running:
		if eventTarget == ProjectSettings.get("Player"):
			ProjectSettings.get("Player").active_events.push_back(self)
		GLOBAL.running_events.push_back(self)
		running = true
		current_page = return_current_page(get_node("pages").get_child(0))
		while player.get_moving():
			yield(get_tree(), "idle_frame")
		if (current_page == null):
			return
		if Imagen != null and Imagen.get_width() / 32 > 1 and !DirectionFix:
			#if from == "up":
				get_node("Sprite").frame = from#0
			#elif from == "down":
				#get_node("Sprite").frame = 12
			#elif from == "left":
				#get_node("Sprite").frame = 8
			#elif from == "right":
				#get_node("Sprite").frame = 4
		player.set_can_interact(false)
		print(current_page.get_name())
		current_page.run()
		yield(current_page, "finished")
		if Imagen != null and Imagen.get_width() / 32 > 1 and !DirectionFix:
			get_node("Sprite").frame = initialFrame
		player.set_can_interact(!BlockPlayerAtEnd)
		print("event " + get_name() + " finished")
		running = false
		if eventTarget == ProjectSettings.get("Player"):
			ProjectSettings.get("Player").active_events.erase(self)
		GLOBAL.running_events.erase(self)
		if deleteAtEnd:
			remove()

func exec_this_page(page):
	print("exec_this-page")
	var p
	if (page<0 or page>=get_node("pages").get_child_count()):
		return
	p = get_node("pages").get_child(page)
	player.set_can_interact(false)
	p.run()
	yield(p, "finished")
	player.set_can_interact(!BlockPlayerAtEnd)

func _execEventTouch(target):
	if Pasable:
		if target.is_in_group("Evento"):
			exec()
	
func _execPlayerTouch(target):
		if target.get_parent().get_name() == "Player":
			print("PLAYER TOUCH")
			eventTarget = target.get_parent()
			#target.get_parent().event = self
			#if Pasable:# or player.can_interact:
			exec()
			#target.get_parent().event = null
				#target.get_parent().event = null

func return_current_page(curr):
	for c in get_node("pages").get_children():
			if c.condition1 != null:
				if GLOBAL.get_node(c.condition1).state:
					print(GLOBAL.get_node(c.condition1).state)
					return c
			elif c.condition2 != null:
				if GLOBAL.get_node(c.condition2).state:
					return c
			elif c.condition3 != null:
				if GLOBAL.get_node(c.condition3).state:
					return c
	return curr
	
	
#Funció per eliminar el nodo de l'evento. Només potfer queue_free() si està dins l SceneTree	
func remove():
	if is_inside_tree():
    	queue_free()
	else:
    	call_deferred("free")