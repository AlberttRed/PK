
extends Panel

const MAX_CHARS_PER_LINE = 41

export(String,MULTILINE) var msg = "¡Hola a todos! ¡Bienvenidos al mundo de POKÉMON! ¡Me llamo OAK! ¡Pero la gente me llama el PROFESOR POKÉMON!"

var label
var label2
var next
var timer
var a
var accept
var writing
func _init():
	add_user_signal("text_displayed")
	add_user_signal("input")
	add_user_signal("finished")
	add_user_signal("finished_waiting")
func _ready():
	label = get_node("Label")
	label2 = get_node("Label/Label2")
	next = get_node("next")
	timer = get_node("Timer 2")
	#show_msg("¡Hola a todos! ¡Bienvenidos al mundo de POKÉMON! ¡Me llamo OAK! ¡Pero la gente me llama el PROFESOR POKÉMON!")
	hide()

func show_msg(text="", wait = null, obj = null, sig = "", options = [], close = true):
	if (text.empty()):
		print("sierrate")
		hide()
		return
	print("msg")
	show()	
	if wait != null:
		next.hide()
	var skp=0
	label.visible_characters = 0
	label2.visible_characters = 0
	text = autoclip(text)
	label.set_text(text)
	label2.set_text(text)
	label.scroll_following = true
	label2.scroll_following = true
	label.scroll_to_line(0)
	label2.scroll_to_line(0)
	var eol1=-1
	var eol2=-1
	while (label.visible_characters < label.text.length()-1):
		label.visible_characters += 1
		label2.visible_characters += 1
		if (text[label.visible_characters]=='\n'):
			print(str(label.visible_characters))
			if (skp >= 1):
				if wait == null:
					next.show()
					next.get_node("AnimationPlayer").play("Idle")
					#if !writing:
					while (!INPUT.ui_accept.is_action_just_pressed()):#(!Input.is_action_pressed("ui_accept")):
						yield(get_tree(), "idle_frame")
					next.get_node("AnimationPlayer").stop()	

					next.hide()
				label.scroll_to_line(skp)
				label2.scroll_to_line(skp)
			skp+=1
			eol1=eol2
			#eol2=label.visible_characters-1
		timer.start()
		yield(timer, "timeout")
	label.visible_characters += 1
	label2.visible_characters += 1
	emit_signal("text_displayed")
	if (obj != null and sig!=""):
		yield(obj,sig)
	if wait == null:
		next.show()
		next.get_node("AnimationPlayer").play("Idle")
		#if !writing:
		while (!INPUT.ui_accept.is_action_just_pressed()):# and options == []):#(!Input.is_action_pressed("ui_accept")):
			yield(get_tree(), "idle_frame")
		next.get_node("AnimationPlayer").stop()		
		next.hide()
		print(str(close) + " " + str(options))
		if close and options == null:
			print("dew")
			hide()
	if wait != null:
		wait(wait)
		yield(self, "finished_waiting")
		hide()
	emit_signal("input")
	emit_signal("finished")

func clear_msg():
	hide()
	
func wait(seconds):
	var t = Timer.new()
	t.set_wait_time(seconds)
	add_child(t)
	t.start()
	yield(t,"timeout")
	t.queue_free()
	emit_signal("finished_waiting")
#func _process(delta):
#	if (INPUT.ui_accept.is_action_just_released()):
#		accept = true

#	text = autoclip(text)
#	label.set_text(text)
#	show()
#	label.set_lines_skipped(0)
#	label.set_percent_visible(0)
#	var percent_per_char = 1.0/float(text.length())
#	var current = -1
#	var eol1=-1
#	var eol2=-1
#	var skp=-1
#	while (current < text.length()-1):
#		current+=1
#		label.set_percent_visible(percent_per_char*float(current-eol1))
#		if (text[current]=='\n'):
#			if (skp >= 0):
#				next.show()
#				while (!Input.is_action_pressed("ui_accept")):
#					yield(get_tree(), "idle_frame")
#				next.hide()
#			skp+=1
#			eol1=eol2
#			eol2=current-1
#			label.set_lines_skipped(skp)
#			label.set_percent_visible(percent_per_char*float(current-eol1))
#		timer.start()
#		yield(timer, "timeout")
#	emit_signal("text_displayed")
#	if (obj != null and sig!=""):
#		yield(obj,sig)
#	next.show()
#	while (!Input.is_action_pressed("ui_accept")):
#		yield(get_tree(), "idle_frame")
#	next.hide()
#	hide()

func autoclip(text=""):
	writing = true
	var lines = [""]
	for p in text.split("\n", false):
		for w in p.split(" ", false):
			if (lines[lines.size()-1].length()+w.length()+1 <= MAX_CHARS_PER_LINE):
				if lines[lines.size()-1] == "":
					lines[lines.size()-1] = w
				else:
					lines[lines.size()-1] += " "+w;
			else:
				lines.append(w)
	text = ""
	for l in range(lines.size()-1):
		#print(lines[l])
		text += lines[l] + "\n"
	#print(lines[lines.size()-1])
	text += lines[lines.size()-1]
	writing = false
	return text
