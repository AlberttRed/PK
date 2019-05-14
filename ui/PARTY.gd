
extends Panel

var style_selected
var style_empty

export(StyleBox) var style_rounded_normal
export(StyleBox) var style_rounded_normal_sel
export(StyleBox) var style_rounded_fainted
export(StyleBox) var style_rounded_fainted_sel
export(StyleBox) var style_rounded_swap
export(StyleBox) var style_rounded_swap_sel

export(StyleBox) var style_square_normal
export(StyleBox) var style_square_normal_sel
export(StyleBox) var style_square_empty
export(StyleBox) var style_square_fainted
export(StyleBox) var style_square_fainted_sel
export(StyleBox) var style_square_swap
export(StyleBox) var style_square_swap_sel

export(StyleBox) var style_salir
export(StyleBox) var style_salir_sel

onready var pkmns = [get_node("PKMN_0"),get_node("PKMN_1"),get_node("PKMN_2"),get_node("PKMN_3"),get_node("PKMN_4"),get_node("PKMN_5")]
onready var salir = get_node("Salir")
var signals = ["pokedex","pokemon","item","player","save","option","exit"]
var start
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
	connect("exit", self, "hide")

var index = 0


func show_party():
	load_pokemon()
	update_styles()
	pkmns[0].grab_focus()
	show()
	
func hide_party():
	for p in range(GAME_DATA.party.size()):
		pkmns[p].visible = false
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
#	if (INPUT.ui_down.is_action_just_pressed()): #Input.is_action_pressed("ui_down"):#
#		var i = index
#		while (i < pkmns.size()-1):
#			i+=1
#			if (pkmns[i].is_visible()):
#				index=i
#				break
#		update_styles()
#	if (INPUT.ui_up.is_action_just_pressed()):#Input.is_action_pressed("ui_up"):#(INPUT.up.is_action_just_pressed()):
#		var i = index
#		while (i > 0):
#			i-=1
#			if (pkmns[i].is_visible()):
#				index=i
#				break
#		update_styles()
	if visible:
		if (INPUT.ui_accept.is_action_just_pressed()):#Input.is_action_pressed("ui_accept"):#(INPUT.ui_accept.is_action_just_pressed()):
			if get_focus_owner().get_name() == "Salir":
					emit_signal("salir")
			else:
					pass
					#show_actions
		if (INPUT.ui_cancel.is_action_just_pressed()):#Input.is_action_pressed("ui_cancel"):#(INPUT.ui_cancel.is_action_just_pressed()):
			index = -1
			salir.grab_focus()
			update_styles()
	
#	if Input.is_action_pressed("ui_start"):#(INPUT.ui_cancel.is_action_just_pressed()):
#		emit_signal("exit")

		
func update_styles():
	var form = ""
	var type = ""
#	if index != -1:
	salir.add_stylebox_override("panel", style_salir)
	for p in range(pkmns.size()):
		if p == 0:
			form = "rounded"
		else:
			form = "square"
		
		if GAME_DATA.party[p].hp == 0:
			type = "fainted"
		else:
			type = "normal"
		
		if (p==index):
			pkmns[p].add_stylebox_override("panel", get("style_" + form + "_" + type + "_sel"))
		else:
			pkmns[p].add_stylebox_override("panel", get("style_" + form + "_" + type))
	if index == -1:
		salir.add_stylebox_override("panel", style_salir_sel)
		
	
func load_pokemon():
	for p in range(GAME_DATA.party.size()):
		pkmns[p].visible = true
		pkmns[p].get_node("Nombre").text = GAME_DATA.party[p].get_nick()
		pkmns[p].get_node("Nombre/Outline").text = GAME_DATA.party[p].get_nick()
		
		pkmns[p].get_node("Nivel").text = "Nv." + str(GAME_DATA.party[p].get_level())
		pkmns[p].get_node("Nivel/Outline").text = "Nv." + str(GAME_DATA.party[p].get_level())
		
		pkmns[p].get_node("HP").text = str(GAME_DATA.party[p].get_actual_hp()) + "/" + str(GAME_DATA.party[p].get_hp())
		pkmns[p].get_node("HP/Outline").text = str(GAME_DATA.party[p].get_actual_hp()) + "/" + str(GAME_DATA.party[p].get_hp())
		
		pkmns[p].get_node("pkmn").texture = load("res://Sprites/Icons/icon" + str(GAME_DATA.party[p].pkm_id).pad_zeros(3) + ".png")
		
		var percentage = GAME_DATA.party[p].get_actual_hp() / GAME_DATA.party[p].get_hp()
		pkmns[p].get_node("health_bar/health").rect_scale = Vector2(percentage, 1)
		
		if GAME_DATA.party[p].get_gender() == CONST.GENEROS.MACHO:
			pkmns[p].get_node("gender").texture = load("res://ui/Pictures/male_icon.png")
		elif GAME_DATA.party[p].get_gender() == CONST.GENEROS.HEMBRA:
			pkmns[p].get_node("gender").texture = load("res://ui/Pictures/female_icon.png")
		else:
			pkmns[p].get_node("gender").texture = null
			
	if GAME_DATA.party.size() == 1:
		pkmns[0].set_focus_neighbour(MARGIN_BOTTOM, "../Salir")
		pkmns[0].set_focus_neighbour(MARGIN_RIGHT, "../PKMN_0")
	if GAME_DATA.party.size() == 2:
		pkmns[0].set_focus_neighbour(MARGIN_BOTTOM, "../Salir")
		pkmns[1].set_focus_neighbour(MARGIN_BOTTOM, "../Salir")
	if GAME_DATA.party.size() == 3:
		pkmns[1].set_focus_neighbour(MARGIN_BOTTOM, "../Salir")
		pkmns[2].set_focus_neighbour(MARGIN_BOTTOM, "../Salir")
		pkmns[2].set_focus_neighbour(MARGIN_RIGHT, "../PKMN_2")
	if GAME_DATA.party.size() == 4:
		pkmns[2].set_focus_neighbour(MARGIN_BOTTOM, "../Salir")
		pkmns[3].set_focus_neighbour(MARGIN_BOTTOM, "../Salir")
	if GAME_DATA.party.size() == 5:
		pkmns[3].set_focus_neighbour(MARGIN_BOTTOM, "../Salir")
		pkmns[4].set_focus_neighbour(MARGIN_BOTTOM, "../Salir")
		pkmns[4].set_focus_neighbour(MARGIN_RIGHT, "../PKMN_4")
	if GAME_DATA.party.size() == 6:
		pkmns[4].set_focus_neighbour(MARGIN_BOTTOM, "../Salir")
		pkmns[5].set_focus_neighbour(MARGIN_BOTTOM, "../Salir")
		
		

#func _on_Salir_focus_entered():
#	index = -1

func _on_PKMN_focus_entered():
	index = int(get_focus_owner().get_name().right(0))
	update_styles()


func _on_Salir_focus_entered():
	index = -1
	update_styles()
