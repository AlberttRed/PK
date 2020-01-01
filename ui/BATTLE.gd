
extends Control

const BATTLEC = preload("res://ui/battle/BATTLE_Constants.gd")

var enemy
var player
#var active_pokemon = null setget set_active_pokemon,get_active_pokemon
var focused_command
var battlers = []
var weatherEffectsFlag
var fieldEffectsFlag = []
var esCombateDoble

var pokemons = []
var actions = []
var moves_target = []

var player_active_pokemons = []
var enemy_active_pokemons = []

var finish_battle = false

export(NodePath)var active_pokemon_node


onready var HPbar_playerS = get_node("Background/HPbar_playerS/")
onready var HPbar_playerD1 = get_node("Background/HPbar_playerD/")
onready var HPbar_playerD2 = get_node("Background/HPbar_playerD2/")
onready var HPbar_enemyS = get_node("Background/HPbar_enemyS/")
onready var HPbar_enemyD1 = get_node("Background/HPbar_enemyD/")
onready var HPbar_enemyD2 = get_node("Background/HPbar_enemyD2/")




onready var enemy_sprite = get_node("Background/enemyBase/pkmn_enemy")
onready var enemy_ally_sprite = get_node("Background/enemyBase/pkmn_enemy_ally")
onready var player_sprite = get_node("Background/playerBase/pkmn_player")
onready var player_ally_sprite = get_node("Background/playerBase/pkmn_player_ally")
onready var trainerenemy_sprite = get_node("Background/enemyBase/pkmn_enemy/trainer")
onready var trainerenemy_ally_sprite = get_node("Background/enemyBase/pkmn_enemy_ally/trainer")
onready var trainerplayer_sprite = get_node("Background/playerBase/pkmn_player/trainer")
onready var trainerplayer_ally_sprite = get_node("Background/playerBase/pkmn_player_ally/trainer")

onready var pokeball1 = get_node("Background/enemyBase/pkmn_enemy/pokeball")
onready var pokeball2 = get_node("Background/enemyBase/pkmn_enemy_ally/pokeball")

onready var enemy_base_sprite = get_node("Background/enemyBase")
onready var player_base_sprite = get_node("Background/playerBase")

onready var player_party = get_node("Background/playerParty")
onready var enemy_party = get_node("Background/enemyParty")

onready var lblTotalHP = get_node("Background/HPbar_playerS/lblTotalHP")
onready var lblActualHP = get_node("Background/HPbar_playerS/lblActualHP")
onready var lblPlayerName = get_node("Background/HPbar_playerS/lblName")
onready var lblEnemyName = get_node("Background/HPbar_enemyS/lblName")
onready var lblEnemyLevel = get_node("Background/HPbar_enemyS/lblLevel")
onready var lblPlayerLevel = get_node("Background/HPbar_playerS/lblLevel")
onready var panelPlayerStatus = get_node("Background/HPbar_playerS/Status")
onready var panelEnemyStatus = get_node("Background/HPbar_enemyS/Status")
onready var commands = get_node("Panel_Commands")
onready var moves = get_node("Panel_Moves")
onready var cmdLuchar = get_node("Panel_Commands/Commands/Luchar")
onready var cmdPokemon = get_node("Panel_Commands/Commands/Pokemon")
onready var cmdMochila = get_node("Panel_Commands/Commands/Mochila")
onready var cmdHuir = get_node("Panel_Commands/Commands/Huir")
onready var cmdMove1 = get_node("Panel_Moves/Moves/Move1")
onready var cmdMove2 = get_node("Panel_Moves/Moves/Move2")
onready var cmdMove3 = get_node("Panel_Moves/Moves/Move3")
onready var cmdMove4 = get_node("Panel_Moves/Moves/Move4")
onready var moveType = get_node("Panel_Moves/MoveType")
onready var actualPP = get_node("Panel_Moves/lblActualPP")
onready var TotalPP = get_node("Panel_Moves/lblTotalPP")
onready var playerHealthBar = get_node("Background/HPbar_playerS/health_bar/health")
onready var playerExpBar = get_node("Background/HPbar_playerS/exp_bar/exp")
onready var enemyHealthBar = get_node("Background/HPbar_enemyS/health_bar/health")
var move = false

#onready var attack_list = get_node("attack_list")
onready var anim = get_node("AnimationPlayer1")
func _init():
	pass
	
func _ready():
	add_user_signal("finished_waiting")
	add_user_signal("select")
	add_user_signal("action_selected")
	add_user_signal("initialized")
	add_user_signal("turn_finished")
	
	ProjectSettings.set("Battle_AnimationPlayer", anim)
	hide()
#	commands.connect("fight", commands, "hide")
#	commands.connect("fight", attack_list, "show")
#	attack_list.connect("cancel", commands, "show")
#	attack_list.connect("cancel", attack_list, "hide")
	pass
	
func start_battle():
	anim.play("init_wild_battle")
##
#func set_active_pokemon(pkm):
#	active_pokemon = pkm
#	if (pkm != null):
#		for i in range(4):
#			if i < active_pokemon.movements.size():
#				print("carregat move " + active_pokemon.movements[i].get_name())
#				moves.get_node("Moves/Move" + str(i+1) + "/lblMove" + str(i+1)).text = active_pokemon.movements[i].get_name()
#				#moves.get_node("Move" + str(i+1) + "/lblMove" + str(i+1)).get_stylebox("panel", "" ).region_rect = Rect2(Vector2(0, active_pokemon.movements[0].get_type().panelMove_y), Vector2(192, 46))
#			else:
#				moves.get_node("Moves/Move" + str(i+1) + "/lblMove" + str(i+1)).text = "-"
#				#moves.get_node("Move" + str(i+1) + "/lblMove" + str(i+1)).get_stylebox("panel", "" ).region_rect = Rect2(Vector2(0, 828), Vector2(192, 46))
#func get_active_pokemon():
#	return active_pokemon
##func _init(trainer, is_playable, trainer_node, pkmn_node, hp_bar_S_node, hp_bar_D_node, base_node, party_node, allies, enemies, doble):


#func start_battle(doble, trainer1, trainer2, trainer3 = null, trainer4 = null):
#	esCombateDoble = doble
#	GUI.msg.get_stylebox("panel", "" ).set_texture(load("res://ui/Pictures/battleMessage.png"))
#	battlers.push_back(Battler.new(trainer1,trainer1.is_playable,trainerplayer_sprite,[player_sprite, player_ally_sprite],HPbar_playerS,[HPbar_playerD1,HPbar_playerD2],player_base_sprite,player_party,trainer3,[trainer2, trainer4],doble,CONST.BATTLE.BACK_SINGLE_SPRITE_POS,[CONST.BATTLE.BACK_DOUBLE1_SPRITE_POS,CONST.BATTLE.BACK_DOUBLE2_SPRITE_POS],trainer1.battle_back_sprite,true,[null, null]))
#	battlers.push_back(Battler.new(trainer2,trainer2.is_playable,trainerenemy_sprite,[enemy_sprite,enemy_ally_sprite],HPbar_enemyS,[HPbar_enemyD1,HPbar_enemyD2],enemy_base_sprite,enemy_party,trainer4,[trainer1, trainer3],doble,CONST.BATTLE.FRONT_SINGLE_SPRITE_POS,[CONST.BATTLE.FRONT_DOUBLE1_SPRITE_POS,CONST.BATTLE.FRONT_DOUBLE2_SPRITE_POS],trainer2.battle_front_sprite,false,[pokeball1, pokeball2]))
#	if trainer3 != null:
#		battlers.push_back(Battler.new(trainer3,trainer3.is_playable,trainerplayer_ally_sprite,[player_ally_sprite,player_sprite],HPbar_playerS,[HPbar_playerD2,HPbar_playerD1],player_base_sprite,player_party,trainer1,[trainer2, trainer4],doble,CONST.BATTLE.BACK_SINGLE_SPRITE_POS,[CONST.BATTLE.BACK_DOUBLE2_SPRITE_POS,CONST.BATTLE.BACK_DOUBLE1_SPRITE_POS],trainer3.battle_back_sprite,true,[null, null]))
#	else:
#		battlers.push_back(null)
#	if trainer4 != null:
#		battlers.push_back(Battler.new(trainer4,trainer4.is_playable,trainerenemy_ally_sprite,[enemy_ally_sprite,enemy_sprite],HPbar_enemyS,[HPbar_enemyD2,HPbar_enemyD1],enemy_base_sprite,enemy_party,trainer2,[trainer1, trainer3],doble,CONST.BATTLE.FRONT_SINGLE_SPRITE_POS,[CONST.BATTLE.FRONT_DOUBLE2_SPRITE_POS,CONST.BATTLE.FRONT_DOUBLE1_SPRITE_POS],trainer4.battle_front_sprite,false,[pokeball2, pokeball1]))
#	else:
#		battlers.push_back(null)
#
#	set_pokemons()
#	init_enemies()
#
#	if !doble:
#		#if battlers[0].allies == null:
#			trainerplayer_ally_sprite.visible = false
#			trainerplayer_sprite.set_position(CONST.BATTLE.BACK_SINGLE_TRAINER_POS)
#
#		#if battlers[1].allies == null:
#			trainerenemy_ally_sprite.visible = false
#			pokeball2.visible = false
#			trainerenemy_sprite.set_position(CONST.BATTLE.FRONT_SINGLE_TRAINER_POS)
#			#enemy_sprite.set_position(CONST.BATTLE.FRONT_SINGLE_SPRITE_POS)
#			pokeball1.set_position(CONST.BATTLE.FRONT_SINGLE_BALL_POS)
#	else:
#			if battlers[0].allies == null:
#				trainerplayer_ally_sprite.visible = false
#				trainerplayer_sprite.set_position(CONST.BATTLE.BACK_SINGLE_TRAINER_POS)
#
#			if battlers[1].allies == null:
#				trainerenemy_ally_sprite.visible = false
#				#pokeball2.visible = false
#				trainerenemy_sprite.set_position(CONST.BATTLE.FRONT_SINGLE_TRAINER_POS)
#				#enemy_sprite.set_position(CONST.BATTLE.FRONT_SINGLE_SPRITE_POS)
#				#pokeball1.set_position(CONST.BATTLE.FRONT_BALL_POS)
#
#	if is_wild_battle():
#		init_wild_battle(doble)
#		yield(self, "initialized")
#	else:
#		init_trainer_battle(doble)
#		yield(self, "initialized")
#
#
#	while !finish_battle:
#		for b in battlers:
#			if b != null:
#				for p in b.active_pokemon:
#					active_pokemon = p
#					if b.is_playable:
#						print("size: " + str(b.active_pokemon.size()))
#						active()
#						commands.get_node("Label_Text").text = "¿Qué debe hacer " + str(active_pokemon.nickname) + "?"
#						commands.show()
#						commands.get_node("Commands").get_node("Luchar").grab_focus()
#						yield(self, "action_selected")
#
#					else:
#						# FALTA APLICAR IA
#						actions.push_back(Command.new(active_pokemon.movements[0].get_name(), active_pokemon, active_pokemon.movements[0], select_move_targets(active_pokemon.movements[0]), false))					
#					anim.stop()
#		#		actions.push_back(Command.new("Huir", 4))
#		#		actions.push_back(Command.new("Luchar", 1))
#		#		actions.push_back(trainer1.movements[0])
#		#		actions.push_back(Command.new("Objeto", 3))
#		#		actions.push_back(Command.new("Cambio", 2))
#		set_actions_priority()
#		update_turn()
#		yield(self, "turn_finished")
#
#func init_wild_battle(double):
#
#	for b in battlers:
#		if double:
#			pass
#		else:
#			active_pokemon = b.active_pokemon
#			#enemy = battlers[1]
#			if b.is_playable:
#				player_sprite.texture = load("res://Sprites/Battlers/" + str(active_pokemon.pkm_id).pad_zeros(3) + "b.png")#.set_frame(0)
#			else:
#				enemy_sprite.texture = load("res://Sprites/Battlers/" + str(active_pokemon.pkm_id).pad_zeros(3) + ".png")##.set_frame(pkm_id)
#			init_screen_single()
#			anim.play("Wild_Start")
#			while anim.is_playing():
#				yield(get_tree(), "idle_frame")
#			if !b.is_playable:
#				GUI.show_msg(active_pokemon.nickname + " salvaje apareció!", true)#, t, "timeout")
#				yield(GUI.msg, "finished")
#
#	emit_signal("initialized")
#
#	#yield(self, "move_selected")
#
#func init_trainer_battle(double):
##		for b in battlers:
##			for p in b.active_pokemon:
##				active_pokemon_node = b.active_pokemon.node
#
##
##		if !double:
##			pass
##		else:
#			#active_pokemon = battlers[0].active_pokemon[0]
#
#			#enemy = battlers[1].party[0]
##			if b.is_playable:
##				player_sprite.texture = load("res://Sprites/Battlers/" + str(active_pokemon.pkm_id).pad_zeros(3) + "b.png")#.set_frame(0)
##			else:
##				enemy_sprite.texture = load("res://Sprites/Battlers/" + str(active_pokemon.pkm_id).pad_zeros(3) + ".png")##.set_frame(pkm_id)
#			#init_screen_single()
#			anim.play("ShowTrainers_parties_animation")
#			wait(1.0)
#			yield(self, "finished_waiting")
#
#			if battlers[0].enemies[0].allies != null:
#				GUI.show_msg("¡" + battlers[0].enemies[0].Name + " y " + battlers[0].enemies[1].Name + " te desafían!", 1.0)
#			else:
#				GUI.show_msg("¡" + battlers[0].enemies[0].Name + " te desafía!", 1.0)
#			yield(GUI, "finished")
#			while anim.is_playing():
#				yield(get_tree(), "idle_frame")
#			GUI.clear_msg()
#			if double:
#				if battlers[0].enemies[0].allies != null:
#					GUI.show_msg("¡" + battlers[0].enemies[0].Name + " y " + battlers[0].enemies[1].Name + " sacan a " + battlers[0].enemies[0].active_pokemon[0].nickname + " y " + battlers[0].enemies[1].active_pokemon[0].nickname + "!", 1.0)
#				else:
#					GUI.show_msg("¡" + battlers[0].enemies[0].Name + " saca a " + battlers[0].enemies[0].active_pokemon[0].nickname + " y " + battlers[0].enemies[0].active_pokemon[1].nickname + "!", 1.0)
#			else:
#				GUI.show_msg("¡" + battlers[0].enemies[0].Name + " saca a " + battlers[0].enemies[0].active_pokemon[0].nickname + "!", 1.0)
#			if double:
#				anim.get_animation("ShowPokemon_enemy").track_insert_key(23, 0.0, true)
#			anim.play("ShowPokemon_enemy")		
#			while anim.is_playing():
#				yield(get_tree(), "idle_frame")	
#			GUI.clear_msg()
#			battlers[1].showPokemon()
#			if battlers[3] != null:
#				battlers[3].showPokemon()
#			while anim.is_playing():
#				yield(get_tree(), "idle_frame")	
#
#			if double:
#				if battlers[0].allies != null:
#					GUI.show_msg("¡Adelante " + battlers[0].active_pokemon[0].nickname + " y " + battlers[0].allies.active_pokemon[0].nickname + "!", 1.0)
#				else:
#					GUI.show_msg("¡Adelante " + battlers[0].active_pokemon[0].nickname + " y " + battlers[0].active_pokemon[1].nickname + "!", 1.0)
#			else:
#				GUI.show_msg("¡Adelante " + battlers[0].active_pokemon[0].nickname + "!", 1.0)
#
#			anim.get_animation("ShowPokemon_player").track_insert_key(2, 0.0, trainerplayer_sprite.get_position())
#			anim.get_animation("ShowPokemon_player").track_insert_key(3, 0.0, trainerplayer_ally_sprite.get_position())
#			anim.play("ShowPokemon_player")		
#			while anim.is_playing():
#				yield(get_tree(), "idle_frame")	
#			battlers[0].showPokemon()
#			while pokemons[0].node.get_node("AnimationPlayer").is_playing():
#				yield(get_tree(), "idle_frame")	
#			if battlers[2] != null:
#				battlers[2].showPokemon()
#			while anim.is_playing():
#				yield(get_tree(), "idle_frame")	
#			GUI.clear_msg()
#			emit_signal("initialized")
#
#func init_screen_single():
#	pass
##	lblEnemyName.text = enemy.nickname
##	lblEnemyLevel.text = "Nv" + str(enemy.level)
##	lblPlayerName.text = active_pokemon.nickname
##	lblPlayerLevel.text = "Nv" + str(active_pokemon.level)	
##	lblTotalHP.text = "/" + str(active_pokemon.max_hp)
##	lblActualHP.text = str(active_pokemon.hp)	
##	panelPlayerStatus.texture = null
##	panelEnemyStatus.texture = null
#	#commands.get_node("Label_Text").text = "¿Qué debe hacer " + str(active_pokemon.nickname) + "?"
##
##	if active_pokemon.movements.size() == 4:
##		cmdMove1.set_focus_neighbour(MARGIN_BOTTOM, "../Move1")
##		cmdMove1.set_focus_neighbour(MARGIN_RIGHT, "../Move1")
##	if active_pokemon.movements.size() == 2:
##		cmdMove1.set_focus_neighbour(MARGIN_BOTTOM, "../Move1")
##		cmdMove2.set_focus_neighbour(MARGIN_BOTTOM, "../Move2")
##	if active_pokemon.movements.size() == 3:
##		cmdMove3.set_focus_neighbour(MARGIN_RIGHT, "../Move3")
##		cmdMove2.set_focus_neighbour(MARGIN_BOTTOM, "../Move2")
##
##	playerHealthBar.modulate = BATTLEC.HPCOLORGREEN
##	enemyHealthBar.modulate = BATTLEC.HPCOLORGREEN
#
#func wait(seconds):
#	var t = Timer.new()
#	t.set_wait_time(seconds)
#	add_child(t)
#	t.start()
#	yield(t,"timeout")
#	t.queue_free()
#	emit_signal("finished_waiting")
#
#func _on_Luchar_focus_entered():
#	reset_commands()
#	set_focus_on_command(cmdLuchar, 130, 0)
#
#func _on_Pokmon_focus_entered():
#	reset_commands()
#	set_focus_on_command(cmdPokemon, 130, 46)
#
#func _on_Mochila_focus_entered():
#	reset_commands()
#	set_focus_on_command(cmdMochila, 130, 92)
#
#func _on_Huir_focus_entered():
#	reset_commands()
#	set_focus_on_command(cmdHuir, 130, 138)
#
#func _on_Move1_focus_entered():
#	reset_commands()
#	set_focus_on_command(cmdMove1, 192, active_pokemon.movements[0].get_move_type().panelMove_y)	
#	moveType.frame = active_pokemon.movements[0].get_move_type().get_typeImage()
#	update_pps(0)
#
#func _on_Move2_focus_entered():
#	reset_commands()
#	set_focus_on_command(cmdMove2, 192, active_pokemon.movements[1].get_move_type().panelMove_y)
#	moveType.frame = active_pokemon.movements[1].get_move_type().get_typeImage()
#	update_pps(1)
#
#func _on_Move3_focus_entered():
#	reset_commands()
#	set_focus_on_command(cmdMove3, 192, active_pokemon.movements[2].get_move_type().panelMove_y)
#	moveType.frame = active_pokemon.movements[2].get_move_type().get_typeImage()
#	update_pps(2)
#
#func _on_Move4_focus_entered():
#	reset_commands()
#	set_focus_on_command(cmdMove4, 192, active_pokemon.movements[3].get_move_type().panelMove_y)
#	moveType.frame = active_pokemon.movements[3].get_move_type().get_typeImage()
#	update_pps(3)
#
#func reset_commands():
#	cmdLuchar.show_behind_parent = true
#	cmdPokemon.show_behind_parent = true
#	cmdMochila.show_behind_parent = true
#	cmdHuir.show_behind_parent = true
#	cmdMove1.show_behind_parent = true
#	cmdMove2.show_behind_parent = true
#	cmdMove3.show_behind_parent = true
#	cmdMove4.show_behind_parent = true
#
#	cmdLuchar.get_stylebox("panel", "" ).region_rect = Rect2(Vector2(0, 0), Vector2(130, 46))
#	cmdPokemon.get_stylebox("panel", "" ).region_rect = Rect2(Vector2(0, 46), Vector2(130, 46))
#	cmdMochila.get_stylebox("panel", "" ).region_rect = Rect2(Vector2(0, 92), Vector2(130, 46))
#	cmdHuir.get_stylebox("panel", "" ).region_rect = Rect2(Vector2(0, 138), Vector2(130, 46))
#
#	if active_pokemon.movements.size() >= 1:
#		cmdMove1.visible = true
#		cmdMove1.get_stylebox("panel", "" ).region_rect = Rect2(Vector2(0, active_pokemon.movements[0].get_move_type().panelMove_y), Vector2(192, 46))
#	if active_pokemon.movements.size() >= 2:
#		cmdMove2.visible = true
#		cmdMove2.get_stylebox("panel", "" ).region_rect = Rect2(Vector2(0, active_pokemon.movements[1].get_move_type().panelMove_y), Vector2(192, 46))
#	if active_pokemon.movements.size() >= 3:
#		cmdMove3.visible = true
#		cmdMove3.get_stylebox("panel", "" ).region_rect = Rect2(Vector2(0, active_pokemon.movements[2].get_move_type().panelMove_y), Vector2(192, 46))
#	if active_pokemon.movements.size() == 4:
#		cmdMove4.visible = true
#		cmdMove4.get_stylebox("panel", "" ).region_rect = Rect2(Vector2(0, active_pokemon.movements[3].get_move_type().panelMove_y), Vector2(192, 46))
#
#func set_focus_on_command(command, x, y):
#	command.show_behind_parent = false
#	command.get_stylebox("panel", "" ).region_rect = Rect2(Vector2(x, y), Vector2(x, 46))
#	focused_command = command
#
#func _input(event):
#	if commands.visible or moves.visible:
#		if event.is_action_pressed("ui_accept"):
#			if focused_command.get_name() == "Luchar":
#				load_moves()
#			elif focused_command.get_name() == "Pokemon":
#				print("pokemon")
#				#actions.push_back(Command.new(active_pokemon, null, active_pokemon, 6))
#			elif focused_command.get_name() == "Mochila":
#				print("mochila")
#				#actions.push_back(Command.new(active_pokemon, null, active_pokemon, 6))
#			elif focused_command.get_name() == "Huir":
#				actions.push_back(Command.new("Huir", active_pokemon, null, [active_pokemon], true, 6))
#				emit_signal("action_selected")
#			elif focused_command.get_name() == "Move1" and !move:
#				if active_pokemon.movements[0].pp > 0:
#
#					actions.push_back(Command.new(active_pokemon.movements[0].get_name(), active_pokemon, active_pokemon.movements[0], select_move_targets(active_pokemon.movements[0]), true))
#					#actions.push_back(active_pokemon.movements[0])
##					if enemy_active_pokemons.size() > 1:
##						select_move_targets(active_pokemon.movements[0])
##					else:
##						moves_target.push(enemy_active_pokemons[0])
#					moves.hide()
#					commands.show()
#					cmdLuchar.grab_focus()
#					emit_signal("action_selected")
#				else:
#					yield(GUI.show_msg("¡No quedan PPs para este movimiento!", false), "finished")
#				#move = true
#
#				#active_pokemon.movements[0].doMove()
#				#active_pokemon.movements[0].ShowAnimation()
#				#active_pokemon.movements[0].pp -= 1
#				#update_pps(0)
##				wait(2.0)
##				yield(self, "finished_waiting")
##				yield(get_tree(), "idle_frame")
##				GUI.clear_msg()
##				move = false
#			elif focused_command.get_name() == "Move2" and !move:
#				if active_pokemon.movements[1].pp > 0:
#					actions.push_back(Command.new(active_pokemon.movements[1].get_name(), active_pokemon, active_pokemon.movements[1], select_move_targets(active_pokemon.movements[1]), true))
##					if enemy_active_pokemons.size() > 1:
##						select_move_target(active_pokemon.movements[1]) #funció de seleccionar a quin pokemon ataquem
##					else:
##						moves_target.push(enemy_active_pokemons[0])
#					moves.hide()
#					commands.show()
#					cmdLuchar.grab_focus()
#					emit_signal("action_selected")
#				else:
#					yield(GUI.show_msg("¡No quedan PPs para este movimiento!", false), "finished")
##				GUI.show_msg("¡" + active_pokemon.nickname + " ha usado " + active_pokemon.movements[1].get_name() + "!", false)
##				yield(GUI.msg, "finished")
##				active_pokemon.movements[1].doMove()
##				active_pokemon.movements[1].ShowAnimation()
##				active_pokemon.movements[1].pp -= 1
##				update_pps(1)
##				wait(2.0)
##				yield(self, "finished_waiting")
##				yield(get_tree(), "idle_frame")
##				GUI.clear_msg()
#			elif focused_command.get_name() == "Move3" and !move:
#				if active_pokemon.movements[2].pp > 0:
#					actions.push_back(Command.new(active_pokemon.movements[2].get_name(), active_pokemon, active_pokemon.movements[2], select_move_targets(active_pokemon.movements[2]), true))
##					if enemy_active_pokemons.size() > 1:
##						select_move_target(active_pokemon.movements[2])
##					else:
##						moves_target.push(enemy_active_pokemons[0])
#					moves.hide()
#					commands.show()
#					cmdLuchar.grab_focus()
#					emit_signal("action_selected")
#				else:
#					yield(GUI.show_msg("¡No quedan PPs para este movimiento!", false), "finished")
##				GUI.show_msg("¡" + active_pokemon.nickname + " ha usado " + active_pokemon.movements[2].get_name() + "!", false)
##				yield(GUI.msg, "finished")
##				active_pokemon.movements[2].doMove()
##				active_pokemon.movements[2].ShowAnimation()				
##				active_pokemon.movements[2].pp -= 1
##				update_pps(2)
##				wait(2.0)
##				yield(self, "finished_waiting")
##				yield(get_tree(), "idle_frame")
##				GUI.clear_msg()
#			elif focused_command.get_name() == "Move4" and !move:
#				if active_pokemon.movements[3].pp > 0:
#					actions.push_back(Command.new(active_pokemon.movements[3].get_name(), active_pokemon, active_pokemon.movements[3], select_move_targets(active_pokemon.movements[3]), true))
##					if enemy_active_pokemons.size() > 1:
##						#select_move_target(active_pokemon.movements[3])
##						pass
##					else:
##						moves_target.push(enemy_active_pokemons[0])
#					moves.hide()
#					commands.show()
#					cmdLuchar.grab_focus()
#					emit_signal("action_selected")
#				else:
#					yield(GUI.show_msg("¡No quedan PPs para este movimiento!", false), "finished")
##				GUI.show_msg("¡" + active_pokemon.nickname + " ha usado " + active_pokemon.movements[3].get_name() + "!", false)
##				yield(GUI.msg, "finished")
##				active_pokemon.movements[3].doMove()
##				active_pokemon.movements[3].pp -= 1
##				update_pps(3)
##				wait(2.0)
##				yield(self, "finished_waiting")
##				yield(get_tree(), "idle_frame")
##				GUI.clear_msg()
##			emit_signal("select")
#		if event.is_action_pressed("ui_cancel"):
#			if !commands.visible:
#				moves.hide()
#				commands.show()
#				cmdLuchar.grab_focus()
#
#func load_moves():
#	for i in range(4):
#		if i < active_pokemon.movements.size():
#			print("carregat move " + active_pokemon.movements[i].get_name())
#			moves.get_node("Moves/Move" + str(i+1) + "/lblMove" + str(i+1)).text = active_pokemon.movements[i].get_name()
#			#moves.get_node("Move" + str(i+1) + "/lblMove" + str(i+1)).get_stylebox("panel", "" ).region_rect = Rect2(Vector2(0, active_pokemon.movements[0].get_type().panelMove_y), Vector2(192, 46))
#		else:
#			moves.get_node("Moves/Move" + str(i+1) + "/lblMove" + str(i+1)).text = "-"
#			#moves.get_node("Move" + str(i+1) + "/lblMove" + str(i+1)).get_stylebox("panel", "" ).region_rect = Rect2(Vector2(0, 828), Vector2(192, 46))
#
#
#	if active_pokemon.movements.size() == 1:
#		cmdMove1.set_focus_neighbour(MARGIN_BOTTOM, "../Move1")
#		cmdMove1.set_focus_neighbour(MARGIN_RIGHT, "../Move1")
#	if active_pokemon.movements.size() == 2:
#		cmdMove1.set_focus_neighbour(MARGIN_BOTTOM, "../Move1")
#		cmdMove2.set_focus_neighbour(MARGIN_BOTTOM, "../Move2")
#	if active_pokemon.movements.size() == 3:
#		cmdMove3.set_focus_neighbour(MARGIN_RIGHT, "../Move3")
#		cmdMove2.set_focus_neighbour(MARGIN_BOTTOM, "../Move2")
#
#
#
#	playerHealthBar.modulate = BATTLEC.HPCOLORGREEN
#	enemyHealthBar.modulate = BATTLEC.HPCOLORGREEN
#	moves.show()
#	commands.hide()	
#	cmdMove1.grab_focus()
#
#func update_pps(m):
#	actualPP.text = str(active_pokemon.movements[m].pp)
#	TotalPP.text = "/" + str(active_pokemon.movements[m].max_pp)
#
#func is_double_battle():
#	return esCombateDoble
#
#func is_wild_battle():
#	var count = 0
#	for b in battlers:
#		if count > 0:
#			if b.is_trainer:
#				return false
#		count += 1
#	return true
#
#func set_pokemons():
#	pokemons.push_back(battlers[0].party[0])
#	player_active_pokemons.push_back(battlers[0].party[0])
#	battlers[0].party[0].battle_position = CONST.BATTLE.SINGLE_BACK_SLOT
#	if is_double_battle():
#		battlers[0].party[0].battle_position = CONST.BATTLE.DOUBLE_BACK_SLOT_1
#		if battlers[2] != null:
#			pokemons.push_back(battlers[2].party[0])
#			player_active_pokemons.push_back(battlers[2].party[0])
#			battlers[2].party[0].battle_position = CONST.BATTLE.DOUBLE_BACK_SLOT_2
#		else:
#			pokemons.push_back(battlers[0].party[1])
#			player_active_pokemons.push_back(battlers[0].party[1])
#			battlers[0].party[1].battle_position = CONST.BATTLE.DOUBLE_BACK_SLOT_2
#
#	pokemons.push_back(battlers[1].party[0])
#	enemy_active_pokemons.push_back(battlers[1].party[0])
#	battlers[1].party[0].battle_position = CONST.BATTLE.SINGLE_FRONT_SLOT
#	if is_double_battle():
#		battlers[1].party[0].battle_position = CONST.BATTLE.DOUBLE_FRONT_SLOT_1
#		if battlers[3] != null:
#			pokemons.push_back(battlers[3].party[0])
#			enemy_active_pokemons.push_back(battlers[3].party[0])
#			battlers[3].party[0].battle_position = CONST.BATTLE.DOUBLE_FRONT_SLOT_2
#		else:
#			pokemons.push_back(battlers[1].party[1])
#			enemy_active_pokemons.push_back(battlers[1].party[1])
#			battlers[1].party[1].battle_position = CONST.BATTLE.DOUBLE_FRONT_SLOT_2
#
#
#
#func set_actions_priority():
#	print("Unsorted array: ")
#	for a in actions:
#		print(a.get_name())
#
#	actions.sort_custom(MyCustomSorter, "sort_by_priority")
#
#	print("Sorted array: ")
#	for a in actions:
#		print(a.get_name())
#
#func select_move_targets(_move):
#	return [active_pokemon.enemies[0]]
#	#if move.get_target_id() == CONST.MOVE_TARGETS.NORMAL:
##	if active_pokemon.is_playable():
##		return enemy_active_pokemons[0]
##	else:
##		return player_active_pokemons[0]
#
#func update_turn():
#	for a in actions:
#		if a.object_action != null:
#			if a.get_type() == "Move":
#				if a.is_player():
#					GUI.show_msg("¡" + a.from.nickname + " usó " + a.object_action.get_name() + "!", 1.0)
#				else:
#					GUI.show_msg("¡El " + a.from.nickname + " enemigo usó " + a.object_action.get_name() + "!", 1.0)
#				yield(GUI, "finished")
#				#GUI.clear_msg()
#				for t in a.to:
#					a.object_action.doMove(a.from,t)
#					while anim.is_playing():
#						yield(get_tree(), "idle_frame")
#					GUI.show_msg("¡Es muy efectivo!", 1.0)
#					yield(GUI, "finished")
#					#GUI.clear_msg()
#			elif a.get_type() == "Pokemon":
#				pass
#			elif a.get_type() == "Object":
#				pass
#		else:
#			commands.hide()
#			hide()
#	GUI.clear_msg()
#	actions.clear()
#	emit_signal("turn_finished")
#
#func init_enemies():
#	battlers[0].enemies.push_back(battlers[1])
#	battlers[1].enemies.push_back(battlers[0])
#	if battlers[2] != null:#battlers.size() >= 3:
#		battlers[0].allies = battlers[2]
#		battlers[2].allies = battlers[0]
#		battlers[2].enemies.push_back(battlers[1])
#		battlers[1].enemies.push_back(battlers[2])
#	if battlers[3] != null:#battlers.size() == 4:
#		battlers[1].allies = battlers[3]
#		battlers[3].allies = battlers[1]
#		if battlers[2] != null:
#			battlers[2].enemies.push_back(battlers[3])
#			battlers[3].enemies.push_back(battlers[2])
#		battlers[0].enemies.push_back(battlers[3])
#		battlers[3].enemies.push_back(battlers[0])
#
#
#
#func active():
#		if anim.has_animation("active"):
#			anim.remove_animation("active")
#		anim.add_animation("active",Animation.new())
#		var animation = anim.get_animation("active")
#		animation.length = 1.0
#		animation.loop = true
#		animation.add_track(Animation.TYPE_VALUE)
#		animation.track_set_path(0, "Background/playerBase/" + active_pokemon.node.name + ":position")
#		animation.track_insert_key(0, 0.0, active_pokemon.node.get_position() + Vector2(0,2))
#		animation.track_insert_key(0, 0.5, active_pokemon.node.get_position() - Vector2(0,2))	
#		animation.add_track(Animation.TYPE_VALUE)
#		animation.track_set_path(1, "Background/" + active_pokemon.hp_bar.name + ":position")
#		animation.track_insert_key(1, 0.0, active_pokemon.hp_bar.get_position() + Vector2(0,2))
#		animation.track_insert_key(1, 0.5, active_pokemon.hp_bar.get_position() - Vector2(0,2))	
#
#		anim.play("active")
#
#func hasWorkingWeather(weather):
#	return weatherEffectsFlag == weather
#
#class MyCustomSorter:
#	static func sort_by_priority(a, b):
#		if a.get_priority() > b.get_priority():
#			return true
#		elif a.get_priority() == b.get_priority():
#			if a.from.get_speed() > b.from.get_speed():
#				return true
#		return false
#
#class Command:
#	var Name
#	var priority
#	var from
#	var to
#	var object_action
#	var player
#	func _init(_Name, _from, _object_action, _to, _player, _priority = null):
#		self.Name = _Name
#		self.from = _from
#		self.to = _to
#		self.object_action = _object_action
#		self.player = _player
#		if priority != null:
#			self.priority = _priority
#		else:
#			self.priority = _object_action.get_priority()
#		print("new command")
#
#	func get_name():
#		return Name
#
#	func get_priority():
#		return priority
#
#	func get_type():
#		return object_action.get_type()
#
#	func is_player():
#		return player
#
#class Battler:
#	var trainer
#	var Name
#	var party
#	var is_playable
#	var active_pokemon = []
#	var is_trainer
#	var doble
#	var trainer_node
#	var pkmn_node
#	var hp_bar
#	var base
#	var party_node
#	var allies # array dels battlers que son alliats d aquest battler i per tan lluiten al seu costat
#	var enemies = [] # array dels battlers que son enemics d aquest battler i per tan lluiten contra ell
#	var single_position
#	var double_position
#	var animationPlayer
#	var trainer_sprite
#	var back
#	var pokeballs
#	func _init(_trainer, _is_playable, _trainer_node, _pkmn_node, _hp_bar_S_node, _hp_bar_D_node, _base_node, _party_node, _allies, _enemies, _doble, _single_position, _double_position, _trainer_sprite, _back, _pokeballs):
#		add_user_signal("finished_waiting")
#		self.trainer = _trainer
#		self.Name = _trainer.get_name()
#		self.is_playable = _is_playable
#		if _trainer.get_type() == "Pokemon":
#			self.party = [_trainer]
#			self.is_trainer = false
#		else:
#			self.party = _trainer.party
#			self.is_trainer = true
#		self.doble = _doble
#		self.trainer_node = _trainer_node
#		self.pkmn_node = _pkmn_node
#		self.base = _base_node
#		self.party_node = _party_node
#		self.single_position = _single_position
#		self.double_position = _double_position
#		self.allies = _allies
#		self.animationPlayer = AnimationPlayer.new()
#		self.trainer_sprite = _trainer_sprite
#		self.back = _back
#		self.pokeballs = _pokeballs
##		self.enemies = enemies
#		if _doble:
#			if self.allies == null:
#				self.active_pokemon.push_back(get_first_pkmn())
#				self.active_pokemon.push_back(get_first_pkmn())
#			else:
#				self.active_pokemon.push_back(get_first_pkmn())
#		else:
#			self.active_pokemon.push_back(get_first_pkmn())
#
#		if _doble:
#			if self.allies == null:#if active_pokemon.size() == 2:
#				active_pokemon[0].hp_bar = _hp_bar_D_node[0]
#				active_pokemon[1].hp_bar = _hp_bar_D_node[1]
#			else:
#				active_pokemon[0].hp_bar = _hp_bar_D_node[0]
#		else:
#			active_pokemon[0].hp_bar = _hp_bar_S_node
#
#		#if is_playable:	
#		if self.allies == null:#if active_pokemon.size() == 2:
#			active_pokemon[0].node = _pkmn_node[0]
#			active_pokemon[0].pokeball_node = _pokeballs[0]
#			active_pokemon[0].battle_double_position = self.double_position[0]#CONST.BATTLE.BACK_DOUBLE1_SPRITE_POS
#			if doble:
#				active_pokemon[1].node = _pkmn_node[1]
#				active_pokemon[1].pokeball_node = _pokeballs[1]
#				active_pokemon[1].battle_double_position = self.double_position[1]#CONST.BATTLE.BACK_DOUBLE2_SPRITE_POS
#		else:
#			active_pokemon[0].node = _pkmn_node[0]
#			active_pokemon[0].pokeball_node = _pokeballs[0]
#			active_pokemon[0].battle_double_position = self.double_position[0]
#
#
##		else:
##			if active_pokemon.size() == 2:
##				active_pokemon[0].node = pkmn_node[0]
##				active_pokemon[1].node = pkmn_node[1]
##				active_pokemon[0].battle_double_position = self.battle_double_position[0]#CONST.BATTLE.FRONT_DOUBLE1_SPRITE_POS
##				active_pokemon[1].battle_double_position = self.battle_double_position[1]#CONST.BATTLE.FRONT_DOUBLE2_SPRITE_POS
##			else:
##				active_pokemon[0].node = pkmn_node[0]
##				active_pokemon[0].battle_double_position = self.battle_double_position[0]
#
#		init_UI()
#
#	func get_first_pkmn():
#		for p in party:
#			if !p.in_battle:
#				if p.hp > 0:
#					p.in_battle = true
#					p.base = self.base
#					return p
#				else:
#					return null
#		return null
#
#	func init_UI():
#	#if is_playable:
#		self.trainer_node.texture = self.trainer_sprite
#		if self.trainer_node.texture.get_size().x > 128:
#			self.trainer_node.vframes = 1
#			self.trainer_node.hframes = 5
#			self.trainer_node.frame = 0
#	#else:
#		#self.trainer_node.texture = trainer.battle_front_sprite
#		for p in active_pokemon:
##			if is_playable:
##				pass
##				#p.node.texture = load("res://Sprites/Battlers/" + str(p.pkm_id).pad_zeros(3) + "b.png")#.set_frame(0)
##			else:
##				pass
#				#p.node.texture = load("res://Sprites/Battlers/" + str(p.pkm_id).pad_zeros(3) + ".png")##.set_frame(pkm_id)
#
#			p.hp_bar.get_node("lblName").text = p.nickname
#			p.hp_bar.get_node("lblLevel").text = "Lv" + str(p.level)
#			p.hp_bar.get_node("lblActualHP").text = str(p.hp_actual)
#			p.hp_bar.get_node("lblTotalHP").text = "/" + str(p.hp)
#			p.hp_bar.get_node("Status").texture = null
#
#	func showPokemon(pokemons = active_pokemon):
#		var final_position
#		#var anim = ProjectSettings.get("Battle_AnimationPlayer")
#		var i = 1
#
#		if doble:
#			if allies != null and allies.active_pokemon.size() > 0:
#				active_pokemon[0].ally = allies.active_pokemon[0]
#			elif allies == null:
#				active_pokemon[0].ally = active_pokemon[1]
#				active_pokemon[1].ally = active_pokemon[0]
#
#
#
#
#		for p in pokemons:
#			p.print_pokemon()
#			p.hp_bar.init(p.get_hp(), p.get_actual_hp())
#			p.enemies.clear()
#			if enemies.size() == 1:
#				for p_en in enemies[0].active_pokemon:
#					p.enemies.push_back(p_en)
#			elif enemies.size() == 2:
#				for e in enemies:
#					for p_en in enemies[0].active_pokemon:
#						p.enemies.push_back(p_en)
#
#			var animplayer
#
#			if back:
#				animplayer = p.node.get_node("AnimationPlayer")
#				p.node.get_node("Sprite").texture = load("res://Sprites/Battlers/" + str(p.pkm_id).pad_zeros(3) + "b.png")
##				animation.add_track(Animation.TYPE_VALUE)
##				animation.track_set_path(0, "Background/" + base.name + "/" + p.node.name + ":position") #pkmn_player
##				animation.track_insert_key(0, 0.0, CONST.BATTLE.BACK_BALL_POS)
##				animation.track_insert_key(0, 0.4, final_position + Vector2(59.8,-24))
##				animation.track_insert_key(0, 0.7, final_position + Vector2(85.6,16))
##				animation.track_insert_key(0, 0.9, final_position + Vector2(108,160))
##				animation.track_insert_key(0, 1.0, final_position + Vector2(80,100))
##				animation.track_insert_key(0, 1.5, (final_position))
##
##
##				animation.add_track(Animation.TYPE_VALUE)
##				animation.track_set_path(1, "Background/"+ base.name + "/" + p.node.name + ":rotation_degrees")
##				animation.track_insert_key(1, 0.0, 0)
##				animation.track_insert_key(1, 0.2, 180)
##				animation.track_insert_key(1, 0.4, 360)
##				animation.track_insert_key(1, 0.6, 540)
##				animation.track_insert_key(1, 0.8, 720)
##				animation.track_insert_key(1, 0.9, 900)
##				animation.track_insert_key(1, 1.0, 0)
##
##				animation.add_track(Animation.TYPE_VALUE)
##				animation.track_set_path(2, "Background/"+ base.name + "/" + p.node.name + ":scale")
##				animation.track_insert_key(2, 0.9, Vector2(0.00001,0.00001))
##				animation.track_insert_key(2, 1.5, Vector2(1,1))
##
##				animation.add_track(Animation.TYPE_VALUE)
##				animation.track_set_path(3, "Background/"+ base.name + "/" + p.node.name + ":material:shader_param/whitening")
##				animation.track_insert_key(3, 1.0, 1)
##				animation.track_insert_key(3, 1.4, 1)
##				animation.track_insert_key(3, 1.5, 0)
##
##				animation.add_track(Animation.TYPE_VALUE)
##				animation.track_set_path(4, "Background/"+ base.name + "/" + p.node.name + ":texture")
##				animation.track_insert_key(4, 0.0, load("res://ui/BattlePictures/small_ball.png"))			
##				animation.track_insert_key(4, 1.0, load("res://Sprites/Battlers/" + str(p.pkm_id).pad_zeros(3) + "b.png"))
##
##				animation.add_track(Animation.TYPE_VALUE)
##				animation.track_set_path(5, "Background/"+ base.name + "/" + p.node.name + ":centered")
##				animation.track_insert_key(5, 0.0, true)
##				animation.track_insert_key(5, 1.0, false)
##
##				animation.add_track(Animation.TYPE_VALUE)
##				animation.track_set_path(6, "Background/" + p.hp_bar.name + ":position")
##				animation.track_insert_key(6, 0.0, p.hp_bar.get_position())
##				animation.track_insert_key(6, 1.0, p.hp_bar.get_position())
##				animation.track_insert_key(6, 1.5,  p.hp_bar.get_position() - Vector2(254,0))
#				animplayer.play("Show_Pokemon_Slot" + str(p.battle_position))
#			else:
#
#				if GUI.battle.get_node("AnimationPlayer" + str(i)).is_playing():
#					animplayer = GUI.battle.get_node("AnimationPlayer" + str(i+1))
#				else:
#					animplayer = GUI.battle.get_node("AnimationPlayer" + str(i))
#				animplayer.add_animation(p.node.name, Animation.new())
#				#anim.clear_caches()
#				var animation = animplayer.get_animation(p.node.name)#str(p.pkm_id))#"Show_Pokemon_back")
#				animation.length = 1.5
#				#animation.clear()
#				if doble:
#					final_position = p.battle_double_position
#				else:
#					if back:
#						final_position = p.back_single_position
#					else:
#						final_position = p.front_single_position	
#
#				animation.add_track(Animation.TYPE_VALUE)
#				animation.track_set_path(0, "Background/" + base.name + "/" + p.pokeball_node.name + ":texture") #pkmn_player
#				animation.track_insert_key(0, 0.0, load("res://ui/Pictures/ball00_open.png"))
#
#				animation.add_track(Animation.TYPE_VALUE)
#				animation.track_set_path(1, "Background/" + base.name + "/" + p.node.name + ":scale") #pkmn_player
#				animation.track_insert_key(1, 0.0, Vector2(0.00001,0.00001))
#				animation.track_insert_key(1, 0.6, Vector2(1,1))
#
#				animation.add_track(Animation.TYPE_VALUE)
#				animation.track_set_path(2, "Background/" + base.name + "/" + p.node.name + ":visible") #pkmn_player
#				animation.track_insert_key(2, 0.21, true)
#
#				animation.add_track(Animation.TYPE_VALUE)
#				animation.track_set_path(3, "Background/"+ base.name + "/" + p.node.name + ":material:shader_param/whitening")
#				animation.track_insert_key(3, 0.1, 1)
#				animation.track_insert_key(3, 0.5, 1)
#				animation.track_insert_key(3, 0.6, 0)
#
#				animation.add_track(Animation.TYPE_VALUE)
#				animation.track_set_path(4, "Background/" + base.name + "/" + p.node.name + ":position") #pkmn_player
##				animation.track_insert_key(0, 0.0, CONST.BATTLE.BACK_BALL_POS)
##				animation.track_insert_key(0, 0.4, final_position + Vector2(59.8,-24))
##				animation.track_insert_key(0, 0.7, final_position + Vector2(85.6,16))
##				animation.track_insert_key(0, 0.9, final_position + Vector2(108,160))
#				animation.track_insert_key(4, 0.1, (final_position + Vector2(0,40)) + Vector2(80,100))
#				animation.track_insert_key(4, 0.6, (final_position + Vector2(0,40)))
#
#				animation.add_track(Animation.TYPE_VALUE)
#				animation.track_set_path(5, "Background/" + base.name + "/" + p.pokeball_node.name + ":visible")
#				animation.track_insert_key(5, 0.0, true)
#				animation.track_insert_key(5, 0.7, false)
#
#				animation.add_track(Animation.TYPE_VALUE)
#				animation.track_set_path(6, "Background/" + p.hp_bar.name + ":position")
#				animation.track_insert_key(6, 0.0, p.hp_bar.get_position())
#				animation.track_insert_key(6, 1.0, p.hp_bar.get_position())
#				animation.track_insert_key(6, 1.5,  p.hp_bar.get_position() + Vector2(260,0))
#
#				animation.add_track(Animation.TYPE_VALUE)
#				animation.track_set_path(7, "Background/"+ base.name + "/" + p.node.name + ":texture")
#				animation.track_insert_key(7, 0.0, load("res://Sprites/Battlers/" + str(p.pkm_id).pad_zeros(3) + ".png"))
#
##				animation.add_track(Animation.TYPE_VALUE)
##				animation.track_set_path(8, "Background/" + base.name + "/" + p.node.name + ":material")
##				animation.track_insert_key(8, 0.0, load("res://ui/BattleAnimations/shader_material.tres"))
##				animation.track_insert_key(8, 0.7,Node.new())
#
#	#			animation.add_track(Animation.TYPE_VALUE)
#	#			animation.track_set_path(1, "Background/playerBase/pkmn_player:texture")
#	#			animation.track_insert_key(1, 0.0, preload("res://ui/BattlePictures/ball00.png"))
#
#
#				animplayer.play(p.node.name)#"Show_Pokemon_back")
#			i += 1
#
##		wait(10)
##		yield(self, "finished_waiting")	
#	func wait(seconds):
#		var t = Timer.new()
#		t.set_wait_time(seconds)
#		#add_child(t)
#		t.start()
#		yield(t,"timeout")
##		t.queue_free()
#		emit_signal("finished_waiting")
		
