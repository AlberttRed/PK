extends Node2D

var movesArray = []
var direction
var Target
var moving = false
var SPEED = 2
var GRID = 32
var startPos
var result
var can_move
var parentEvent = null
var parentPage = null

func _init():
	add_user_signal("finished")
	add_user_signal("moved")
	set_physics_process(true)
	
func _ready():
	pass

func run():
	print("Strength started")
	#var animationPlayer = GLOBAL.running_events.back().get_node("AnimationPlayer")
	if !GAME_DATA.ACTUAL_MAP.strength_on:
		GUI.show_msg("Es una roca enorme, pero un POKéMON podría moverla.")
		while (GUI.is_visible()):
			yield(get_tree(),"idle_frame")	
		if GLOBAL.CanDoStrength():
			GUI.show_msg("Quieres usar Fuerza?", null, null, "", [["SÍ","NO"],true,"Choice2"])
			while (GUI.is_visible()):
				yield(get_tree(),"idle_frame")
			if GLOBAL.get_choice_selected() == "Choice1":
				GUI.show_msg(GLOBAL.get_pkmn_selected().get_name() + " usó FUERZA.", 1)
				while (GUI.is_visible()):
					yield(get_tree(),"idle_frame")	
				GUI.show_msg("La FUERZA de " + GLOBAL.get_pkmn_selected().get_name() + " logró desplazar la roca a un lado.")
				while (GUI.is_visible()):
					yield(get_tree(),"idle_frame")	
				GAME_DATA.ACTUAL_MAP.strength_on = true
				GLOBAL.set_pkmn_selected(null)
				print("A empujar!")
	else:
		GUI.show_msg("Usar FUERZA ha permitido desplazar la roca a un lado.")
		while (GUI.is_visible()):
			yield(get_tree(),"idle_frame")
	print("Strength finished")
	emit_signal("finished")
#
#func _physics_process(delta):
#
#	if movesArray.size() != 0:
#		if result == null or result.empty() or can_move:
#			Target.move_and_collide(direction * 1)
#		if Target.get_position() == (startPos + Vector2(GRID * direction.x, GRID * direction.y)) or !can_move:
#			movesArray = []
#			emit_signal("moved")
