extends Node2D

onready var body = get_parent()
var direction
var result = null
var colliders = []

onready var directions = {'RayCastRight': Vector2(CONST.GRID_SIZE, 0),
             'RayCastLeft': Vector2(-CONST.GRID_SIZE, 0),
             'RayCastUp': Vector2(0, -CONST.GRID_SIZE),
             'RayCastDown': Vector2(0, CONST.GRID_SIZE)}
			
#Guardem el contrari del facing. Si el body interecciona miran cap adalt (up, = 12), li tornem l'invers, que seria cap avall (down, = 0)
var facing_inverse = {'right': 4,
	             'left': 8,
	             'up': 1,
	             'down': 12}
			
			
# Called when the node enters the scene tree for the first time.
func _ready():
	direction = directions[get_name()]# Replace with function body.

# Actualitza l'intersact point per detectar si hi ha alguna colisió en la següent cel·la del mapa respecte a la posició actual del parent
func update(cells=1):
	if body.Through:
		result = null
	else:
		result = intersect_point(direction, cells)
	
func intersect_point(dir, cells=1):
	if weakref(GAME_DATA.ACTUAL_MAP).get_ref(): #Comprovem que l'Acual Map s'hagi actualitzat en el cas de canviar de mapa i aixi evitar que doni error
		return body.get_world_2d().get_direct_space_state().intersect_point(body.get_position() + (dir*cells), CONST.GRID_SIZE, get_tree().get_root().get_node("World/CanvasModulate/Area2D_").get_children(), 2147483647, true, true)

func is_colliding():
	#print("SURF: " + str(is_SurfingArea()) + " " + str(body.get_surfing()))
	if result == null or result.empty() or !isnot_Pasable() or (is_SurfingArea() and body.surfing):
		print_colliders()
		return false
	else:
		print("COLLIDING")
		print_colliders()
		return true
		
func is_SurfingArea():
	#print("SURFING?")
	var i = 1
	if result != null:
		for c in get_colliders():
			if c.is_in_group("surf_area"):
				return true
	return false
	
func isnot_Pasable():
	for c in get_colliders():
		if c.is_in_group("Pasable"):
			#print(c.get_name() + " IS PASABLE")
			return false
		else:
			#print(c.get_name() + " is not pasable")
			return true
			
func is_PlayerTouch():
	for c in get_colliders():
		if c.get_name() != "Area2D_" and c.is_in_group("PlayerTouch"):
			print("true")
			return true
	print("false")		
	return false

func get_colliders():
	colliders = []
	for r in result:
		if(r != null):
			colliders.append(r.collider)
	return colliders
	
func print_colliders():
	for c in colliders:
		print(c.get_name())

func interact():
	update()
	for c in get_colliders():
		print("INTERACT")
		if typeof(c) == TYPE_OBJECT and c.is_in_group("Interact"):
			if c.is_in_group("surf_area") and !body.surfing:
				body.surf()
			elif !c.is_in_group("surf_area"):
				c.eventTarget = self
				c.exec(facing_inverse[body.facing])

func interact_at_collide():
	if is_PlayerTouch() and isnot_Pasable() and body.can_interact:
		for c in get_colliders():
			print("INTERACT AT COLLIDE")
			print(c.get_name())
			if typeof(c) == TYPE_OBJECT and c.is_in_group("Evento") and !c.has_node("Boulder"):
				if !c.running and body.facing == body.get_direction():
					body.get_node("AnimationPlayer").stop()
					body.can_interact = c.current_page.Paralelo
					c.eventTarget = self
					c.exec()
					return true
					#EVENTS.add_event(dictionary.collider.get_parent(), self)
			elif typeof(c) == TYPE_OBJECT and c.is_in_group("ledge_area"):
				if c.direction == body.get_direction() and GLOBAL.is_last_move(body.get_direction()):
					body.jump(c.cells_jump)
					return true
			elif typeof(c) == TYPE_OBJECT and c.has_node("Boulder"):
					print("lmao")
					if body.facing == body.get_direction():
						print("BIMBA")
						body.push(c)
						return true
	return false
	
func collides_with(object):
	for c in colliders:
		if c == object:
			return true
	return false

#	func _physics_process(delta):# and !$MoveTween.is_active():
#		if is_colliding():
#			if(get_collider().is_in_group("Map_Area")):
#				if(get_collider().get_groups()[1] != ProjectSettings.get("Actual_Map").get_name()):
#					clear_exceptions()
#					add_exception(get_collider())
#