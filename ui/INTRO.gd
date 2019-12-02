extends Control

export(StyleBox) var style_selected
export(StyleBox) var style_empty

var index = 0
var entries = [] #[get_node("VBoxContainer/Pokedex"),get_node("VBoxContainer/Pokemon"),get_node("VBoxContainer/Mochila"),get_node("VBoxContainer/Jugador"),get_node("VBoxContainer/Guardar"),get_node("VBoxContainer/Opciones"),get_node("VBoxContainer/Salir")]
var signals = [] #["pokedex","pokemon","item","player","save","option","exit"]

func _ready():
	add_user_signal("continue")
	add_user_signal("new_game")
	set_process(false)
	if GAME_DATA.save_exists():
		entries = [$Menu/VBoxContainer/CONTINUE,$"Menu/VBoxContainer/NEW GAME"]
		signals = ["continue","new_game"]
	else:
		entries = [$"Menu/VBoxContainer/NEW GAME"]
		signals = ["new_game"]

func start():
	show()
	$Inicial.visible = true
	$AnimationPlayer.play("fade_out")
	yield($AnimationPlayer, "animation_finished")
	
	$AnimationPlayer.play("start_screen")
	yield($AnimationPlayer, "animation_finished")
	
	$AnimationPlayer.play("press_enter")
	

func _input(event):
	if event.is_action_pressed("ui_start") and $Inicial.visible:
		$AnimationPlayer.stop()
		$Inicial/press_start.visible = false
		$Menu.visible = true
		$Inicial.visible = false
		set_process(true)
		update_styles()

func _process(delta):
	if $Menu.visible:
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
			emit_signal(signals[index])
			$Menu.visible = false
			hide()

func update_styles():
	for p in range(entries.size()):
		if (p==index):
			entries[p].add_stylebox_override("panel", style_selected)
		else:
			entries[p].add_stylebox_override("panel",style_empty)
			