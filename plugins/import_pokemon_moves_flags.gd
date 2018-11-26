tool

extends EditorScript

#var type_script = load("res://logics/DB/pokemon_move.gd")

func _run():
	var scn = get_scene()
	if (scn == null || scn.get_name() != "DB"):
		print("WARNING: not in Database scene!")
		return
		
	var container = scn.get_node("pokemon_moves")

	var word = ""
	var file = File.new()
	file.open("C:/Users/alber/Documents/MOVES_MAKE_CONTACT.txt", file.READ)
	#words = file.get_as_text()
	while !file.eof_reached():
		var equal = false
		word = file.get_line()
		for c in container.get_children():
			if int(c.id) == int(word):
				c.contact_flag = true
				break
		if equal:
			print("OK: " + word)
		else:
			print("NOPE: " + word)
	file.close()
	print("hola")

	


