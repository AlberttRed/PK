extends Node2D

onready var body = get_parent()
var direction
var result = null

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
	if weakref(ProjectSettings.get("Actual_Map")).get_ref(): #Comprovem que l'Acual Map s'hagi actualitzat en el cas de canviar de mapa i aixi evitar que doni error
		return body.get_world_2d().get_direct_space_state().intersect_point(body.get_position() + (dir*cells), CONST.GRID_SIZE, get_tree().get_root().get_node("World/CanvasModulate/Area2D_").get_children(), 2147483647, true, true)

func is_colliding():
	if result == null or result.empty() or !isnot_Pasable() or (is_SurfingArea() and body.surfing):
		return false
	else:
		return true
		
func is_SurfingArea():
	if result != null:
		for c in get_colliders():
			if c.is_in_group("surf_area"):
				return true
	return false
	
func isnot_Pasable():
	for c in get_colliders():
		if c.is_in_group("Pasable"):
			print(c.get_name() + " IS PASABLE")
			return false
		else:
			print(c.get_name() + " is not pasable")
			return true
			
func is_PlayerTouch():
	for c in get_colliders():
		if c.get_name() != "Area2D_" and c.is_in_group("PlayerTouch"):
			print("true")
			return true
	print("false")		
	return false

func get_colliders():
	var colliders = []
	for r in result:
		colliders.append(r.collider)
	return colliders

func interact():
	update()
	for c in get_colliders():
		print("INTERACT")
		if typeof(c) == TYPE_OBJECT and c.is_in_group("Interact"):
			if c.is_in_group("surf_area") and !body.surfing:
				body.surf()
			else:
				c.eventTarget = self
				c.exec(facing_inverse[body.facing])

func interact_at_collide():
	if is_PlayerTouch() and isnot_Pasable() and body.can_interact:
		for c in get_colliders():
			print("INTERACT AT COLLIDE")
			if typeof(c) == TYPE_OBJECT and c.is_in_group("Evento") and !c.is_in_group("Boulder"):
				if !c.running:
					body.get_node("AnimationPlayer").stop()
					body.can_interact = c.current_page.Paralelo
					c.eventTarget = self
					c.exec()
					#EVENTS.add_event(dictionary.collider.get_parent(), self)
			elif typeof(c) == TYPE_OBJECT and c.is_in_group("ledge_area"):
				if c.direction == body.facing:
					body.jump(c.direction, c.cells_jump)
			elif typeof(c) == TYPE_OBJECT and c.is_in_group("Boulder"):
					print("lmao")
					body.push(c)
	

#	func _physics_process(delta):# and !$MoveTween.is_active():
#		if is_colliding():
#			if(get_collider().is_in_group("Map_Area")):
#				if(get_collider().get_groups()[1] != ProjectSettings.get("Actual_Map").get_name()):
#					clear_exceptions()
#					add_exception(get_collider())
#