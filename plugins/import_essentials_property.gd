tool

extends EditorScript

#var poke_script = preload("res://Logics/DB/pokemon.gd")

func _run():
	var scn = get_scene()
	if (scn == null || scn.get_name() != "DB"):
		print("WARNING: not in Database scene!")
		return
		
	var pokemons = scn.get_node("pokemons")
	
	var result = []
	var f = File.new()
	f.open("D:/Documents/Essentials/Pokémon Essentials Esp v16.2 NETA/PBS/pokemon.txt", 1)
	var index = 1
	while not f.eof_reached():
		var line = f.get_line()
		result.push_back(line)
	f.close()
	
	for p in pokemons.get_children():  #maxim son 721
		var readed_pokemon_id = ""
		for line in result:
			#print(line)
			if readed_pokemon_id == "":
				#print("line length: " + str(line.length()) + " first: " + line[0] + " id: " + line[1])
				if line.length() > 0 and line[0] == "[" and line.replace('[', '').replace(']', '') == str(p.id):
					readed_pokemon_id = line.replace('[', '').replace(']', '')
			else:
				if readed_pokemon_id == str(p.id):
					print("Selected " + p.get_name() + " Readed: " + readed_pokemon_id)
					if line.substr(0, 14) == "BattlerPlayerY":
						print("BattlerPlayerY: " + line.substr(15, line.length() - 15))
						p.battlerPlayerY = int(line.substr(15, line.length() - 15))
					elif line.substr(0, 13) == "BattlerEnemyY":
						print("BattlerEnemyY: " + line.substr(14, line.length() - 14))
						p.battlerEnemyY = int(line.substr(14, line.length() - 14))
					elif line.substr(0, 15) == "BattlerAltitude":
						print("BattlerAltitude: " + line.substr(16, line.length() - 16))
						p.battlerAltitude = int(line.substr(16, line.length() - 16))
						break


