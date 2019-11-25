extends "res://Logics/event/Event.gd"

export(Vector2) var inital_position = Vector2(0,0)

var active_events = []
export(bool) var Transparent = false


func _init():
	._init()
	add_user_signal("move")
	add_user_signal("step")
	add_user_signal("jump")
	add_user_signal("controlled_move")
	ProjectSettings.set("Player", self)
	
func _ready():
	._ready()
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
		print_player_variables()
	elif event.is_action_released("ui_cancel") and !GUI.is_visible():
		print("NOT RUNNING")
		set_running(false)
			
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
	print("Position: " + str(position))
	print("exit_door: " + str(GLOBAL.get_node("exit_door").state))
	
