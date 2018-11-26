tool

extends EditorScript

#var type_script = load("res://logics/DB/pokemon_type.gd")

func _run():
	var scn = get_scene()
	if (scn == null || scn.get_name() != "DB"):
		print("WARNING: not in Database scene!")
		return
		
	var container = scn.get_node("pokemon_types")
	if (container == null):
		container = Node.new()
		container.set_name("pokemon_types")
		scn.add_child(container)
		container.set_owner(scn)
		
	var names = PoolStringArray()
	names.push_back("None")

	for i in range(18):

		if (Input.is_key_pressed(KEY_ESCAPE)):
			return
		
		var text = get_json("/api/v2/type/"+str(i+1)+"/")
		
		if (text == null || text == ""):
			print ("skipping type #"+str(i+1))
			continue
		var p_type = Node.new()
		p_type.set_script(preload("res://logics/DB/pokemon_type.gd"))
		#var p_type = type_script.new()
		container.add_child(p_type)
		p_type.set_owner(scn)
		
#		var d = Dictionary()
#		d.parse_json(text)
		var d = parse_json(text)
		print(d["name"])
		p_type.set_name(str(i+1)+" - "+d["name"])
		names.push_back(d["name"])
		
		p_type.id=i+1
		p_type.internal_name=d["name"]
		for n in d["names"]:
			if n["language"]["name"] == "es":
				p_type.Name=n["name"]
		p_type.resistance = Array()
		p_type.no_effect_from = Array()
		p_type.ineffective = Array()
		p_type.weakness = Array()
		p_type.no_effect_to = Array()
		p_type.super_effective = Array()
		
		for res in d["damage_relations"]["half_damage_from"]:
			p_type.resistance.push_back(int(res["url"].split("/")[6]))
		for n_e in d["damage_relations"]["no_damage_from"]:
			p_type.no_effect_from.push_back(int(n_e["url"].split("/")[6]))#int(n_e["url"].split("/")[4]))		
		for inf in d["damage_relations"]["half_damage_to"]:
			p_type.ineffective.push_back(int(inf["url"].split("/")[6]))
		for weak in d["damage_relations"]["double_damage_from"]:
			p_type.weakness.push_back(int(weak["url"].split("/")[6]))
		for n_e in d["damage_relations"]["no_damage_to"]:
			p_type.no_effect_to.push_back(int(n_e["url"].split("/")[6]))
		for s_e in d["damage_relations"]["double_damage_to"]:
			p_type.super_effective.push_back(int(s_e["url"].split("/")[6]))

		
		print("loaded pokemon type: " + p_type.get_name())
	
	scn.pokemon_types = str(names)




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
#	err = http.connect("www.pokeapi.co",80) # Connect to host/port
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
#		var rb = RawArray() #array that will hold the data
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