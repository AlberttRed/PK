
extends Panel

export(StyleBox) var sprite_Bag1
export(StyleBox) var sprite_Bag2
export(StyleBox) var sprite_Bag3
export(StyleBox) var sprite_Bag4
export(StyleBox) var sprite_Bag5
export(StyleBox) var sprite_Bag6
export(StyleBox) var sprite_Bag7
export(StyleBox) var sprite_Bag8

onready var backgrounds = [null, sprite_Bag1, sprite_Bag2, sprite_Bag3, sprite_Bag4, sprite_Bag5, sprite_Bag6, sprite_Bag7, sprite_Bag8]

var background_index = 1
var index = 0
var actions_index = 0

onready var actions = get_node("ACTIONS")
onready var msg = get_node("MSG")

const msgBox_normalSize = Vector2(398, 66)
const msgBox_actionsSize = Vector2(370, 66)


var signals = ["pokedex","pokemon","item","player","save","option","exit"]
var start
var opened = false

func _init():
	add_user_signal("pokedex")
	add_user_signal("pokemon")
	add_user_signal("item")
	add_user_signal("player")
	add_user_signal("save")
	add_user_signal("option")
	add_user_signal("salir")

func _ready():
	hide()
	


#func _input(event):
#	if visible:
#		if INPUT.ui_accept.is_action_just_pressed():#event.is_action_just_pressed("ui_accept"):
#			if get_focus_owner().get_name() == "Salir":
#				emit_signal("salir")
#			else:
#				pass
#				#show_actions
#		elif INPUT.ui_cancel.is_action_just_pressed():#event.is_action_just_pressed("ui_cancel"):
#			index = -1
#			salir.grab_focus()
#			update_styles()
#
				

func _process(delta):
	if INPUT.ui_accept.is_action_just_released():
		opened = true
	if visible:
		if !actions.visible:
			if (INPUT.ui_right.is_action_just_pressed()):
				if background_index < 8:
					background_index += 1
			elif (INPUT.ui_left.is_action_just_pressed()):
				if background_index > 0:
					background_index -= 1
			if (INPUT.ui_accept.is_action_just_pressed()):#Input.is_action_pressed("ui_accept"):#(INPUT.ui_accept.is_action_just_pressed()):
				if opened:
					pass#show_actions()
			if (INPUT.ui_cancel.is_action_just_pressed()):#Input.is_action_pressed("ui_cancel"):#(INPUT.ui_cancel.is_action_just_pressed()):
				if get_focus_owner().get_name() == "Salir":
						emit_signal("salir")
				index = -1

				update_styles()
		elif actions.visible:
			if (INPUT.ui_accept.is_action_just_pressed()):#Input.is_action_pressed("ui_accept"):#(INPUT.ui_accept.is_action_just_pressed()):
				if actions_index == 0:
					print("SUMMARY")
					##show_summaries()
			if (INPUT.ui_cancel.is_action_just_pressed()):#Input.is_action_pressed("ui_cancel"):#(INPUT.ui_cancel.is_action_just_pressed()):
				pass#hide_actions()	update_styles()

		
func update_styles():
	$BAG.add_stylebox_override("panel", backgrounds[background_index])
	