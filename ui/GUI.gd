
extends CanvasLayer

onready var msg = get_node("MSG")
#onready var options = get_node("OPTIONS")
onready var menu = get_node("MAIN_MENU")
onready var battle = get_node("BATTLE")
onready var player=ProjectSettings.get("Player")
onready var chs = get_node("CHOICES")

func _ready():
	add_user_signal("finished")
#menu.connect("option", self, "_on_menu_options")
#	options.connect("text_speed_changed", self, "_on_text_speed_changed")
#
#func _init():
#	get_node("MSG").Panel = CONST.Window_StyleBox
	
func show_msg(text, wait = null, obj = null, sig="", choices_options = []):
	player.can_interact = false
	msg.accept = false
	msg.show_msg(text,wait,obj,sig, choices_options.size() == 0 or choices_options[0] == null)
	yield(msg, "finished")
	if choices_options.size() > 0 and choices_options[0] != null:
		show_choices(choices_options)
		#clear_msg()
	player.can_interact = true
	emit_signal("finished")

func show_choices(choices):
	player.can_interact = false
	for c in choices[0]:
		print("add choice")
		chs.add_choice(c)
#	for c in chs.get_child(0).get_children():
#		print(c.text)
	chs.show_choices(choices[1], choices[2])
	yield(chs, "exit")
	chs.clear_choices()
	msg.clear_msg()
	player.can_interact = true
	emit_signal("finished")

#func show_options():
#	options.show()
#	options.set_process(true)
#	yield(options,"exit")
#	options.set_process(false)

func clear_msg():
	msg.clear_msg()
	
func clear_choices():
	msg.clear_msg()

func show_menu():
	menu.start = false
	menu.show()
	#menu.set_process(true)
	yield(menu,"exit")
	#menu.set_process(false)

func is_visible():
	return msg.is_visible() || menu.is_visible() || battle.is_visible() || chs.is_visible()#|| options.is_visible()

#func _on_text_speed_changed(speed):
#	get_node("MSG/Timer 2").set_wait_time(CONST.TEXT_SPEEDS[speed])

#func _on_menu_options():
#	menu.hide()
#	menu.set_process(false)
#	show_options()
#	yield(options, "exit")
#	menu.show()
#	menu.set_process(true)

func start_battle(double, trainer1, trainer2, trainer3 = null, trainer4 = null):#wild_encounter(id, level):
	battle.show()
	battle.start_battle(double, trainer1, trainer2, trainer3, trainer4)
	#battle.wild_encounter(id, level)