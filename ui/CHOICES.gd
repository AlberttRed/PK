
extends Panel

export(StyleBox) var style_selected
export(StyleBox) var style_empty

onready var entries = []#get_node("VBoxContainer/Pokedex"),get_node("VBoxContainer/Pokemon"),get_node("VBoxContainer/Mochila"),get_node("VBoxContainer/Jugador"),get_node("VBoxContainer/Guardar"),get_node("VBoxContainer/Opciones"),get_node("VBoxContainer/Salir")]
onready var container = get_node("VBoxContainer")
var choice
var num_of_choices
var signals = []#"pokedex","pokemon","item","player","save","option","exit"]
var start

var can_cancel = true
var default_choice = ""

func _init():
#	add_user_signal("pokedex")
#	add_user_signal("pokemon")
#	add_user_signal("item")
#	add_user_signal("player")
#	add_user_signal("save")
#	add_user_signal("option")
	add_user_signal("exit")

func _ready():
	num_of_choices = 0
	hide()
	connect("exit", self, "hide")

var index = 0

func _process(delta):
	if visible:
		if (INPUT.ui_down.is_action_just_pressed()): #Input.is_action_pressed("ui_down"):#
			var i = index
			while (i < entries.size()-1):
				i+=1
				if (entries[i].is_visible()):
					index=i
					break
			update_styles()
		if (INPUT.ui_up.is_action_just_pressed()):#Input.is_action_pressed("ui_up"):#(INPUT.up.is_action_just_pressed()):
			var i = index
			while (i > 0):
				i-=1
				if (entries[i].is_visible()):
					index=i
					break
			update_styles()
		
		if (INPUT.ui_accept.is_action_just_pressed()):#Input.is_action_pressed("ui_accept"):#(INPUT.ui_accept.is_action_just_pressed()):
			print("accept " + signals[index])
			GLOBAL.set_choice_selected(signals[index])
			emit_signal(signals[index])
			emit_signal("exit")
		if (INPUT.ui_cancel.is_action_just_pressed() and can_cancel):#Input.is_action_pressed("ui_cancel"):#(INPUT.ui_cancel.is_action_just_pressed()):
			print("cancel")
			GLOBAL.set_choice_selected(default_choice)
			emit_signal(default_choice)
			emit_signal("exit")
	#	if Input.is_action_pressed("ui_start"):#(INPUT.ui_cancel.is_action_just_pressed()):
	#		emit_signal("exit")

func add_choice(ch):
	num_of_choices = container.get_children().size()
	choice = load("res://ui/choice.tscn").instance()
	choice.set_name(choice.get_name() + str(num_of_choices+1))
	choice.get_child(0).set_text(ch)
	container.add_child(choice)
	rect_size = Vector2(get_rect().size.x, get_rect().size.y + 31*num_of_choices)
	rect_position = Vector2(get_rect().position.x, get_rect().position.y - 31*num_of_choices)
	signals.push_back("Choice" + str(num_of_choices+1))
	entries.push_back(choice)
	update_styles()
	if !has_user_signal("Choice" + str(num_of_choices+1)):
		add_user_signal("Choice" + str(num_of_choices+1))
	
func show_choices(cancel, default):
	can_cancel = cancel
	default_choice = default
	show()
	
func clear_choices():
	reset_panel()
	hide()
	
func reset_panel():
	rect_size = Vector2(101,57)
	rect_position = Vector2(404,227)
	signals.clear()
	entries.clear()
	for c in container.get_children():
		GLOBAL.queue(c)
		
func update_styles():
	for p in range(entries.size()):
		if (p==index):
			entries[p].add_stylebox_override("panel", style_selected)
		else:
			entries[p].add_stylebox_override("panel",style_empty)