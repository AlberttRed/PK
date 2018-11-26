tool

extends EditorScript

#var type_script = load("res://logics/DB/pokemon_move.gd")

func _run():
	var scn = get_scene()
	if (scn == null || scn.get_name() != "DB"):
		print("WARNING: not in Database scene!")
		return
		
	var container = scn.get_node("pokemon_moves")
	if (container == null):
		container = Node.new()
		container.set_name("pokemon_moves")
		scn.add_child(container)
		container.set_owner(scn)
		
	var names = PoolStringArray()
	names.push_back("None")

	for i in range(621):			#621 total

		if (Input.is_key_pressed(KEY_ESCAPE)):
			return
		
		var text = get_json("/api/v2/move/"+str(i+1)+"/")
		
		if (text == null || text == ""):
			print ("skipping type #"+str(i+1))
			continue
		print("hola")
		var p_move = Node.new()
		p_move.set_script(preload("res://logics/DB/pokemon_move.gd"))# = type_script.new()
		container.add_child(p_move)
		p_move.set_owner(scn)
		
#		var d = Dictionary()
#		d.parse_json(text)
		var d = parse_json(text)
		print(d["name"])
		

		
		p_move.id=i+1
		p_move.internal_name=d["name"]
		for n in d["names"]:
			if n["language"]["name"] == "es":
				p_move.set_name(str(i+1)+" - "+n["name"])
				names.push_back(n["name"])
				p_move.Name=n["name"]
				
		for text in d["flavor_text_entries"]:
			if text["language"]["name"] == "es":
				p_move.description = text["flavor_text"]
				
		p_move.type = int(d["type"]["url"].split("/")[6])
		
		if d["power"] == null: 
			p_move.power = 0 
		else: 
			p_move.power = int(d["power"])
			
		if d["accuracy"] == null: 
			p_move.accuracy = 0 
		else: 
			p_move.accuracy = int(d["accuracy"])
			
		if d["effect_chance"] == null: 
			p_move.effect_chance = 0 
		else: 
			p_move.effect_chance = int(d["effect_chance"])

		#p_move.effect_chance = int(d["effect_chance"])
		p_move.priority = int(d["priority"])
		p_move.pp = int(d["pp"])
		p_move.damage_class_id = int(d["damage_class"]["url"].split("/")[6])
		
		for text in d["effect_entries"]:
			if text["language"]["name"] == "en":
				p_move.effect_entries = text["short_effect"] + " " + text["effect"]
		
		p_move.stat_change_ids = Array()
		p_move.stat_change_valors = Array()
		for stat in d["stat_changes"]:
			p_move.stat_change_ids.push_back(int(stat["stat"]["url"].split("/")[6]))
			p_move.stat_change_valors.push_back(int(stat["change"]))
		p_move.target_id = int(d["target"]["url"].split("/")[6])
		
		p_move.meta_ailment_id = int(d["meta"]["ailment"]["url"].split("/")[6])
		p_move.meta_category_id = int(d["meta"]["category"]["url"].split("/")[6])
		if d["meta"]["min_hits"] != null:
			p_move.meta_min_hits = int(d["meta"]["min_hits"])
		if d["meta"]["max_hits"] != null:
			p_move.meta_max_hits = int(d["meta"]["max_hits"])
		if d["meta"]["min_turns"] != null:
			p_move.meta_min_turns = int(d["meta"]["min_turns"])
		if d["meta"]["max_turns"] != null:
			p_move.meta_max_turns = int(d["meta"]["max_turns"])
				
		p_move.meta_drain = int(d["meta"]["drain"])
		p_move.meta_healing = int(d["meta"]["healing"])
		p_move.meta_crit_rate = int(d["meta"]["crit_rate"])
		p_move.meta_ailment_chance = int(d["meta"]["ailment_chance"])
		p_move.meta_flinch_chance = int(d["meta"]["flinch_chance"])
		p_move.meta_stat_chance = int(d["meta"]["stat_chance"])		
		
		
		print("loaded pokemon move: " + p_move.get_name())
	
	scn.pokemon_moves = str(names)


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





#func get_json(uri):
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
#			#While there is body left to be read
#			http.poll()
#			var chunk = http.read_response_body_chunk() # Get a chunk
#			if (chunk.size()==0):
#				#got nothing, wait for buffers to fill a bit
#				OS.delay_usec(50)
#			else:
#				rb = rb + chunk # append to read bufer
#		#done!
#		var text = rb.get_string_from_ascii()
#		return text
#	return ""