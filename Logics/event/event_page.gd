
extends Node

export(String) var condition1
export(String) var condition2
export(String) var condition3
export (bool)var Pasable = false
export (Texture)var Imagen = null
export (bool)var Interact = false
export (bool)var DirectionFix = false
export (bool)var PlayerTouch = false
export (bool)var EventTouch = false
export (bool)var AutoRun = false

var initialFrame
export (int)var sprite_cols = 1
export (int)var sprite_rows = 1
export (Vector2)var OffsetSprite = Vector2(0,4)
var running = false
var running_choice = false
var cmd_move_on = true
var parentEvent = null


func _ready():
	pass
#	if Pasable:
#		makePasable()
		#if Imagen.get_width() / 32 > 1:
			#get_node("Sprite").hframes = (Imagen.get_width() / 32)/2
			#get_node("Sprite").vframes = (Imagen.get_width() / 32)/2
			#get_node("Sprite").offset = Vector2(0,-(Imagen.get_width() / 32)*2)
#	if Interact:
#		add_to_group("Interact")

func _init():
	add_user_signal("finished_page")
	add_user_signal("executed")

func _process(delta):
	if AutoRun:
		AutoRun = false
		run()

func run():
	#exec_commands(get_children())
	call_deferred("exec_commands", get_children())
#	while running:
#		yield(get_tree(), "idle_frame")
	yield(self,"executed")
	print("page finished")
	emit_signal("finished_page")

func exec_commands(commands):
	ProjectSettings.get("Player").can_interact = false
	running = true
	for cmd in commands:
		if cmd.is_in_group("CMD"):
			#print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
			print(cmd.get_name())
			if (cmd.get_name().begins_with("cmd_change_page")):
				get_parent().get_parent().set_page(get_parent().get_child(cmd.page))
			elif (cmd.get_name().begins_with("cmd_move")):
				cmd_move_on = true
				if cmd.nodePath.is_empty():#get_parent().get_parent().eventTarget == ProjectSettings.get("Player"):
					ProjectSettings.get("Player").active_events.push_back(parentEvent)
					ProjectSettings.get("Player").being_controlled = true
					print("HE..RE")
					cmd.call_deferred("run")
					#yield(cmd, "finished")
					print("FINISH")
					#ProjectSettings.get("Player").active_events.erase(get_parent().get_parent())
				else:
					cmd.call_deferred("run")
					print("FINISH")
			elif (cmd.get_name().begins_with("cmd_msg")):
				cmd.run()
				yield(cmd, "finished")
				if cmd.choices != null and cmd.choices.size() != 0:# or (cmd.choices[0] != null and cmd.choices[0].size() != 0):
					running_choice = true
					print("exec commands from " + GLOBAL.get_choice_selected())
					exec_commands(cmd.get_node(GLOBAL.get_choice_selected()).get_children())
					while running_choice:
						yield(get_tree(), "idle_frame")
					print("SACABO")
				elif cmd.get_children().size() > 0:
					for c in cmd.get_children():
						c.run()
						yield(c, "finished")
				print("ups")
			else:
				cmd.run()
				yield(cmd, "finished")
			print("cmd finished")
		if !running_choice:
			running = false
		running_choice = false
	ProjectSettings.get("Player").can_interact = true
	emit_signal("executed")

func is_executing():
	for c in get_children():
		if c.executing:
			return true
	return false

func _execEventTouch(target):
	if Pasable:
		if target.is_in_group("Evento"):
			run()

func _execPlayerTouch(target):
		print("lololo")
		if target.get_parent().get_name() == "Player":
			print("PLAYER TOUCH")
			#eventTarget = target.get_parent()
			#target.get_parent().event = self
			#if Pasable:# or player.can_interact:
			run()
			#target.get_parent().event = null
				#target.get_parent().event = null

#func makePasable():
#	if !is_in_group("Pasable"):
#		parentEvent.add_to_group("Pasable")

func load_sprite():
	if Imagen != null:
		initialFrame = get_node("Sprite").frame
		parentEvent.get_node("Sprite").texture = Imagen
		parentEvent.get_node("Sprite").hframes = sprite_cols
		parentEvent.get_node("Sprite").vframes = sprite_rows
		parentEvent.get_node("Sprite").offset = OffsetSprite
		parentEvent.get_node("Sprite").set_position(Vector2(0,-24))

