tool

extends EditorScript

#var poke_script = preload("res://Logics/DB/pokemon.gd")

func _run():
	var scn = get_scene()
	if (scn == null || scn.get_name() != "DB"):
		print("WARNING: not in Database scene!")
		return
		
	var container = scn.get_node("pokemons")


	for i in range(150):  #maxim son 721

		var text = get_json("/api/v2/pokemon/"+str(i+1)+"/")
		
		if (text == null || text == ""):
			print ("skipping type #"+str(i+1))
			continue
		
		var pkm = container.get_child(i)
		var d = parse_json(text)
		
		pkm.abilities = [null, null, null]
		
		for a in d["abilities"]:
			print("slot: " + str(a["slot"]))
			print("ability id " + str(a["ability"]["url"].split("/")[6]))
			pkm.abilities[int(a["slot"])-1] = int(a["ability"]["url"].split("/")[6])
			

	
		
		
#		for l in d["moves"]:
#			#print("id: " + l["move"]["url"].split("/")[6] + " move: " + l["move"]["name"] + " nivel: " + str(l["version_group_details"][0]["level_learned_at"]) + " id_tipo: " + l["version_group_details"][0]["move_learn_method"]["url"].split("/")[6] + " tipo: " + l["version_group_details"][0]["move_learn_method"]["name"])
#			pkm.learn_type.push_back(int(l["version_group_details"][0]["move_learn_method"]["url"].split("/")[6]))
#			pkm.learn_lvl.push_back(int(l["version_group_details"][0]["level_learned_at"]))
#			pkm.learn_move_id.push_back(int(l["move"]["url"].split("/")[6]))
#
#		pkm.held_item = []
#		pkm.held_item_rarity = []
#
#		for i in d["held_items"]:
#			pkm.held_item.push_back(i["item"]["url"].split("/")[6])
#			pkm.held_item_rarity.push_back(int(i["version_details"][0]["rarity"]))
#
#		var species = parse_json(get_json("/api/v2/pokemon-species/"+str(i+1)+"/"))
#
#		pkm.catch_rate = int(species["capture_rate"])
#		pkm.habitat = int(l["habitat"]["url"].split("/")[6])
#		pkm.forms_switchable = species["forms_switchable"]
#
#		if (species["egg_groups"].size() > 0):
#			pkm.egg_group_a = int(d["egg_groups"][0]["url"].split("/")[6])
#		if (species["egg_groups"].size() > 1):
#			pkm.egg_group_a = int(d["egg_groups"][1]["url"].split("/")[6])
#			pkm.egg_group_b = int(d["egg_groups"][0]["url"].split("/")[6])
#
#		pkm.base_happiness = int(species["base_happiness"])
#
#		for f in species["flavor_text_entries"]:
#			if pkm.short_desc == "":
#				if f["language"]["name"] == "es":
#					pkm.short_desc = f["flavor_text"]
#
#		pkm.hatch_counter = int(species["hatch_counter"])
#
#		for g in species["genera"]:
#			if pkm.especie == "":
#				if g["language"]["name"] == "es":
#					pkm.especie = g["genus"]
		
		
			#print(l["move"]["name"])
#		for e in d["evolutions"]:
#			if (e["method"] == "level_up"):
#				pkm.evol_method.push_back(0)
#			elif (e["method"] == "trade"):
#				pkm.evol_method.push_back(1)
#			elif (e["method"] == "stone"):
#				pkm.evol_method.push_back(2)
#			if (e.has("level")):
#				pkm.evol_lvl.push_back(e["level"])
#			pkm.evol_pokemon_id.push_back(int(e["resource_uri"].split("/")[4]))
#
#		var desc = Dictionary()
#		desc.parse_json(get_json(d["descriptions"][0]["resource_uri"]))
#		pkm.description = desc["description"]
#
#		for l in d["moves"]:
#			if (l["learn_type"]=="machine"):
#				pkm.learn_type.push_back(1)
#				pkm.learn_lvl.push_back(0)
#				pkm.learn_move_id.push_back(int(l["resource_uri"].split("/")[4]))
#			elif (l["learn_type"]=="level up"):
#				pkm.learn_type.push_back(0)
#				pkm.learn_lvl.push_back(l["level"])
#				pkm.learn_move_id.push_back(int(l["resource_uri"].split("/")[4]))
#			elif (l["learn_type"]=="evolve"):
#				pkm.learn_type.push_back(2)
#				pkm.learn_lvl.push_back(0)
#				pkm.learn_move_id.push_back(int(l["resource_uri"].split("/")[4]))
#
#
#		pkm.short_desc = d["species"]
#		pkm.total = int(d["total"])
#		pkm.ev_yield = d["ev_yield"]
#		pkm.growth_rate = d["growth_rate"]
		
		print("loaded pokemon: " + pkm.get_name())
	

func get_json(uri):
	var err = 0
	var http = HTTPClient.new() # Create the Client
	
	err = http.connect_to_host("https://www.pokeapi.co",443) # Connect to host/port
	assert(err == OK) # Make sure connection was OK
	
	# Wait until resolved and connected
	while http.get_status() == HTTPClient.STATUS_CONNECTING or http.get_status() == HTTPClient.STATUS_RESOLVING:
		http.poll()
		print("Connecting..")
		OS.delay_msec(500)

	assert(http.get_status() == HTTPClient.STATUS_CONNECTED) # Could not connect
	
	# Some headers
	var headers = [
	]
	
	err = http.request(HTTPClient.METHOD_GET, uri, headers) # Request a page from the site (this one was chunked..)
	assert(err == OK) # Make sure all is OK
	
	while http.get_status() == HTTPClient.STATUS_REQUESTING:
		# Keep polling until the request is going on
		http.poll()
		print("Requesting..")
		OS.delay_msec(500)
	
	assert(http.get_status() == HTTPClient.STATUS_BODY or http.get_status() == HTTPClient.STATUS_CONNECTED) # Make sure request finished well.
	
	print("response? ", http.has_response()) # Site might not have a response.

	if http.has_response():
		# If there is a response..

		# Getting the HTTP Body

		if http.is_response_chunked():
			# Does it use chunks?
			print("Response is Chunked!")
		else:
			# Or just plain Content-Length
			var bl = http.get_response_body_length()
			print("Response Length: ",bl)
		
		# This method works for both anyway
		
		var rb = PoolByteArray() # Array that will hold the data

		while http.get_status() == HTTPClient.STATUS_BODY:
			# While there is body left to be read
			http.poll()
			var chunk = http.read_response_body_chunk() # Get a chunk
			if chunk.size() == 0:
				# Got nothing, wait for buffers to fill a bit
				OS.delay_usec(1000)
			else:
				rb = rb + chunk # Append to read buffer

		# Done!


		print("bytes got: ", rb.size())
		var text = rb.get_string_from_ascii()
		return text
	return ""



	
#
#	var err=0
#	var http = HTTPClient.new() # Create the Client
#	err = http.connect_to_host("www.pokeapi.co",80) # Connect to host/port
#	assert( err == OK )
#	while( http.get_status()==HTTPClient.STATUS_CONNECTING or http.get_status()==HTTPClient.STATUS_RESOLVING):
#			#Wait until resolved and connected
#		http.poll()
#		OS.delay_msec(50)
#	assert( http.get_status() == HTTPClient.STATUS_CONNECTED ) # Could not connect
#	var headers=[]
#	err = http.request(HTTPClient.METHOD_GET,uri,headers) # Request a page from the site (this one was chunked..)
#	assert( err == OK ) # Make sure all is OK
#	while (http.get_status() == HTTPClient.STATUS_REQUESTING):
#		# Keep polling until the request is going on
#		http.poll()
#		OS.delay_msec(500)
#	assert( http.get_status() == HTTPClient.STATUS_BODY or http.get_status() == HTTPClient.STATUS_CONNECTED ) # Make sure request finished well.
#	if (http.has_response()):
#		var rb = PoolByteArray() #array that will hold the data
#		while(http.get_status()==HTTPClient.STATUS_BODY):
#
#			#While there is body left to be read
#			http.poll()
#			var chunk = http.read_response_body_chunk() # Get a chunk
#			if (chunk.size()==0):
#				#got nothing, wait for buffers to fill a bit
#				OS.delay_usec(5000)
#			else:							
#				print("hola")
#				rb = rb + chunk # append to read bufer
#		#done!
#		var text = rb.get_string_from_ascii()
#		return text
#	return ""
