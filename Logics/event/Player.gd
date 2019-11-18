extends "res://Logics/event/Event.gd"

export(Vector2) var inital_position = Vector2(0,0)

var active_events = []
export(bool) var Transparent = false

func _init():
	._init()
	add_user_signal("move")
	add_user_signal("step")
	add_user_signal("jump")
	ProjectSettings.set("Player", self)
	
func _ready():
	._ready()
	GAME_DATA.trainer = $Trainer
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

func can_move(dir):
	if (Input.is_action_pressed("ui_" + dir) and can_move and !being_controlled and !GUI.is_visible() and !ProjectSettings.get("Global_World").faded and can_interact) or (Input.is_action_pressed("ui_"  + dir + "_event_player") and can_move):
		return true
	return false
	
func set_initial_position(pos):
	set_position(inital_position)
