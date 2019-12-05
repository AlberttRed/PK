
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
onready var pockets = [null, [], [], [], [], [], [], [], []]
var pocket_index = 1
var item_index = 0
var selected_index = 1
var actions_index = 0
var items_on_screen = []

onready var actions = get_node("ACTIONS")
onready var msg = get_node("MSG")

const msgBox_normalSize = Vector2(398, 66)
const msgBox_actionsSize = Vector2(370, 66)


var signals = ["pokedex","pokemon","bag","player","save","option","exit"]
var start
var opened = false

var pocket_name = {1: 'OBJETOS',
			2: 'MEDICINAS',
			3: 'POKÉ BALLS',
			4: 'MTs Y MOs',
             5: 'BAYAS',
			6: 'MAILS',
			7: 'COMBATE',
			8: 'OBJ. CLAVE',}

func _init():
	add_user_signal("pokedex")
	add_user_signal("pokemon")
	add_user_signal("bag")
	add_user_signal("player")
	add_user_signal("save")
	add_user_signal("option")
	add_user_signal("salir")

func _ready():
	hide()
	
func show_bag():
	opened = false
	load_items()
	update_styles()
	show()

func _process(delta):
	if INPUT.ui_accept.is_action_just_released():
		opened = true
	if visible:
		if !actions.visible:
			if (INPUT.ui_right.is_action_just_pressed()):
				item_index = 0
				selected_index = 1
				if pocket_index < 8:
					pocket_index += 1
				update_styles()
			elif (INPUT.ui_left.is_action_just_pressed()):
				item_index = 0
				selected_index = 1
				if pocket_index > 1:
					pocket_index -= 1
				update_styles()
					
			if (INPUT.ui_up.is_action_just_pressed()):
				if item_index > 0:
					item_index -= 1
				if selected_index > 1:
					selected_index -= 1
				update_styles()#update_selected()
			elif (INPUT.ui_down.is_action_just_pressed()):
				if item_index < pockets[pocket_index].size():
					item_index += 1
				if selected_index < 8 and selected_index < items_on_screen.size():
					selected_index += 1
				update_styles()#update_selected()
					
			if (INPUT.ui_accept.is_action_just_pressed()):#Input.is_action_pressed("ui_accept"):#(INPUT.ui_accept.is_action_just_pressed()):
				if opened:
					pass#show_actions()
			if (INPUT.ui_cancel.is_action_just_pressed()):#Input.is_action_pressed("ui_cancel"):#(INPUT.ui_cancel.is_action_just_pressed()):
				emit_signal("salir")
		elif actions.visible:
			if (INPUT.ui_accept.is_action_just_pressed()):#Input.is_action_pressed("ui_accept"):#(INPUT.ui_accept.is_action_just_pressed()):
				if actions_index == 0:
					print("SUMMARY")
					##show_summaries()
			if (INPUT.ui_cancel.is_action_just_pressed()):#Input.is_action_pressed("ui_cancel"):#(INPUT.ui_cancel.is_action_just_pressed()):
				pass#hide_actions()	update_styles()

func load_items():
	for i in GAME_DATA.ITEMS:
		pockets[i[0].bag_pocket].push_back(i)
	print_pockets()
	
func update_styles():
	print("item_index: " + str(item_index))
	print("pocket index: " + str(pocket_index))
	add_stylebox_override("panel", backgrounds[pocket_index])
	$Categoria.text = pocket_name[pocket_index]
	show_pocket()
	update_selected()
	update_silder()
		
func show_pocket():
	load_pocket()
	var count = 0
	for child in $ItemList.get_children():
		child.text = ""
		child.get_node("Quantity").text = ""
	for i in items_on_screen:
		if i == null:
			$ItemList.get_child(count).text = "CERRAR MOCHILA"
		else:
			$ItemList.get_child(count).text = i[0].Name
			if i[0].countable:
				$ItemList.get_child(count).get_node("Quantity").text = "x" + str(i.size())
		count += 1
		
func load_pocket():
	var item_count = 8
	items_on_screen.clear()
	if item_index < 8: #Si estem en els 8 primers objectes, ha de sortir el cerrar mochila + 7 items, en cas contrari que carregui els 8 items
		items_on_screen.push_back(null)
		item_count = 7
	for i in range(item_index-8, item_index+item_count):
		if i >= 0 and pockets[pocket_index].size()-1 >= i:
			items_on_screen.push_back(pockets[pocket_index][i])
#	for i in range(item_index, -1, -1):
#		print("loop: " + str(i))
#		if pockets.size() >= i:
#			items_on_screen.push_back(pockets[i].Name)

func print_pockets():
	for p in range(pockets.size()-1):
		print("POCKET " + str(p+1))	
		for i in pockets[p+1]:
			print(str(i.size()) + " " + i[0].Name)

func update_selected():
	print("selected: " + str(selected_index))
	$Select.position = Vector2($Select.position.x, 31 * selected_index)
	if items_on_screen[selected_index-1] == null:
		$Descripcion.text = "Salir."
	else:
		$Descripcion.text = items_on_screen[selected_index-1][0].description

func update_silder():
	var y_cord = 60.0
	if items_on_screen.size() > 1 and pockets[pocket_index].size()+1 > 1:
		print(str(116.0) + " * (" + str(item_index) + "+1) / (" + str(pockets[pocket_index].size()) + ")")
		y_cord += 116.0 * (float(item_index+1)) / (pockets[pocket_index].size()+1)
	$Slider.position.y = y_cord