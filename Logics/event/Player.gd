extends "res://Logics/event/Event.gd"

export(Vector2) var inital_position = Vector2(0,0)

var active_events = []
export(bool) var Transparent = false
var in_bug_contest = false

func _init():
	._init()
	add_user_signal("move")
	add_user_signal("step")
	add_user_signal("jump")
	add_user_signal("controlled_move")
	GAME_DATA.PLAYER = self
	set_physics_process(false)
	set_physics_process_internal(false)
	#ProjectSettings.set("Player", self)
	
func _ready():
	._ready()
#	DB.add_item(1)
#	DB.add_item(5)
#	DB.add_item(1)
#	DB.add_item("Hiperpoción", 5)
#	DB.add_item("Master Ball")
	GAME_DATA.trainer = trainer
	GAME_DATA.party = $Trainer.get_party()
	$Sprite.visible = !Transparent

func _physics_process(delta):# and !$MoveTween.is_active():

		for dir in moves.keys():
			if can_move(dir):
					can_move = false
					move(dir)
					

func _input(event):
	if event.is_action_pressed("ui_start") and !GUI.is_visible():
		GUI.show_menu()
	
	if event.is_action_pressed("ui_accept") and !GUI.is_visible():	
		direction.interact()

	if event.is_action_pressed("ui_cancel") and !GUI.is_visible():	
		set_running(true)
		print("RUNNING")
		#GAME_DATA.load_game()
#		for e in GAME_DATA.EVENTS_LOADED.get_children():
#			print(e.get_name() + " " + str(e.actual_position))
#		print_player_variables()
#		DB.print_items()
		#print_world()
	elif event.is_action_released("ui_cancel") and !GUI.is_visible():
		print("NOT RUNNING")
		set_running(false)
	elif event.is_action_released("ui_screenshot") and !GUI.is_visible():
		var image = get_viewport().get_texture().get_data()
		image.flip_y()
		image.save_png("C:/Users/aquer/Saved Games/Pokemon Essentials Esp v16_2/screenshot.png")



func can_move(dir):
	if (Input.is_action_pressed("ui_" + dir) and can_move and !being_controlled and !GUI.is_visible() and !ProjectSettings.get("Global_World").faded and can_interact) or (Input.is_action_pressed("ui_"  + dir + "_event_player") and can_move):
		return true
	return false
	
func set_initial_position(pos):
	set_position(inital_position)

func print_player_variables():
	print("====== VARIABLES ======")
	print("Through: " + str(Through))
	print("Transparent: " + str(Transparent))
	print("Can interact: " + str(can_interact))
	print("Can move: " + str(can_move))
	print("Being Controlled: " + str(being_controlled))
	print("Position: " + str(position))
	print("exit_door: " + str(GLOBAL.get_node("exit_door").state))
	for a in GAME_DATA.WORLD.MAP_AREA.get_children():
		print(str(a.get_groups()))
		
func print_world():
	print("---- CAPA TERRA   ----")
	for c in GAME_DATA.WORLD.CAPA_TERRA.get_children():
		print(c.get_name() + " " + str(c.get_groups()) + " " + str(c.get_position()))
	print("---- CAPA TERRA 2 ----")
	for c in GAME_DATA.WORLD.CAPA_TERRA2.get_children():
		print(c.get_name() + " " + str(c.get_groups()) + " " + str(c.get_position()))
	print("---- CAPA TERRA 3 ----")
	for c in GAME_DATA.WORLD.CAPA_TERRA3.get_children():
		print(c.get_name() + " " + str(c.get_groups()) + " " + str(c.get_position()))
	print("---- EVENTOS      ----")
	for c in GAME_DATA.WORLD.EVENTOS.get_children():
		print(c.get_name() + " " + str(c.get_groups()) + " " + str(c.get_position()))
	print("---- CAPA ALTA    ----")
	for c in GAME_DATA.WORLD.CAPA_ALTA.get_children():
		print(c.get_name() + " " + str(c.get_groups()) + " " + str(c.get_position()))
	print("---- MAP AREA     ----")
	for c in GAME_DATA.WORLD.MAP_AREA.get_children():
		print(c.get_name() + " " + str(c.get_groups()) + " " + str(c.get_position()))
	print(GAME_DATA.ACTUAL_MAP.get_name())
	print("Offsets: " + str(GAME_DATA.WORLD.offsets))
	print("Player: " + str(position))
	print("Actual map: " + GAME_DATA.ACTUAL_MAP.get_name())
	
func save():
	var save_dict = {
		"filename" : get_filename(),
		"x_position" : actual_position.x, # Vector2 is not supported by JSON
		"y_position" : actual_position.y, # Vector2 is not supported by JSON
		"Transparent" : Transparent,
		"active_events" : active_events,
		"Through" : Through,
		"speed_animation" : speed_animation,
		"step_speed" : step_speed,
		"can_move" : can_move,
		"facing" : facing,
		"moved" : moved,
		"jumping" : jumping,
		"surfing" : surfing,
		"pushing" : pushing,
		"running" : running,
		"in_event" : in_event,
		"last_facing" : last_facing,
		"can_interact" : can_interact,
		"being_controlled" : being_controlled
	}
	return save_dict
	
func set_all_process(state):
	pass
