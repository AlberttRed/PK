tool

extends EditorScript

#var poke_script = preload("res://Logics/DB/pokemon.gd")

func _run():
	var scn = get_scene()
	if (scn == null || scn.get_name() != "DB"):
		print("WARNING: not in Database scene!")
		return
		
	var container = scn.get_node("items")
	if (container == null):
		container = Node.new()
		container.set_name("items")
		scn.add_child(container)
		container.set_owner(scn)
		
	var names = PoolStringArray()
	names.push_back("None")
	
	for i in range(49):  #maxim son 1005

		var text = get_json("/api/v2/item/"+str(i+1)+"/")
#		var h = HTTPRequest.new()
#		h.request("https://www.pokeapi.co/api/v2/pokemon/"+str(i+1)+"/")
		
		if (text == null || text == ""):
			print ("skipping item #"+str(i+1))
			continue
		var item = Node.new() #load("res://Logics/DB/pokemon.gd") #poke_script.new()
		item.set_script(preload("res://Logics/DB/item.gd"))
		container.add_child(item)
		item.set_owner(scn)
		var d = parse_json(text)
		item.set_name(str(d["id"]) + " - " + str(d["names"][4]["name"]))
		#var d = Dictionary()

		print(str(d["id"]))
		
		item.id=int(d["id"])
		item.internal_name=d["name"]
		item.cost=int(d["cost"])
		item.category=int(d["category"]["url"].split("/")[6])
		item.Name=d["names"][4]["name"]
		item.description = d["flavor_text_entries"][4]["text"]
		var text2 = get_json("/api/v2/item-category/"+str(item.category)+"/")
		if (text2 == null || text2 == "" || text2 == "Not Found"):
			item.category = 0
		else:
			var d2 = parse_json(text2)
			item.bag_pocket = int(d2["pocket"]["url"].split("/")[6])
	
		for a in d["attributes"]:
			match str(a["name"]):
				"countable":
					item.countable = true
				"consumable":
					item.consumable = true
				"usable-overworld":
					item.overworld = true
				"usable-in-battle":
					item.battle = true
				"holdable":
					item.holdable = true
				"holdable-passive":
					item.holdable_passive = true
				"holdable-active":
					item.holdable_active = true
				"underground":
					item.underground = true
#	var bag_pockets = ""
#	for x in range(7):
#		var text2 = get_json("/api/v2/item-pocket/"+str(x+1)+"/")
#		if (text2 == null || text2 == "" || text2 == "Not Found"):
#			print ("skipping specie #"+str(x+1))
#			continue
#		else:
#			var d2 = parse_json(text2)
#			bag_pockets = bag_pockets + str(d2["names"][1]["name"]).to_upper().replace(" ", "_") + ", "
#			print("const " + str(d2["names"][1]["name"]).to_upper().replace(" ", "_") + " = " + str(x+1))
#	print(bag_pockets)




func get_json(uri):
	var http2 = HTTPClient.new()
	var err = http2.connect_to_host("https://pokeapi.co", 443)
	if err != OK:
		print("error")
		return
	# Wait until resolved and connected.
	while http2.get_status() == HTTPClient.STATUS_CONNECTING or http2.get_status() == HTTPClient.STATUS_RESOLVING:
		http2.poll()
		#print("Connecting...")
		
	#print(http2.get_status())
	
	assert(http2.get_status() == HTTPClient.STATUS_CONNECTED) # Could not connect

	# Some headers
	var headers = [
#		"User-Agent: Pirulo/1.0 (Godot)",
#		"Accept: */*"
	]
#"/api/v2/pokemon/1"
	err = http2.request(HTTPClient.METHOD_GET, uri, headers) # Request a page from the site (this one was chunked..)
	assert(err == OK) # Make sure all is OK.
	#print(http2.get_status())
	while (http2.get_status() == HTTPClient.STATUS_REQUESTING):
		#print("poll")
		
		http2.poll()
		OS.delay_msec(500)
	var rb = PoolByteArray()
	while http2.get_status() == HTTPClient.STATUS_BODY:
		http2.poll()
		var chunk = http2.read_response_body_chunk() # Get a chunk.

		if chunk.size() == 0:
				# Got nothing, wait for buffers to fill a bit.
			OS.delay_usec(1000)
		else:
			#print(chunk.get_string_from_ascii())
			rb = rb + chunk
	#print("bytes got: ", rb.size())
	var text = rb.get_string_from_utf8()
	return text
	
	

func get_json_old(uri):
	var err = 0
	var http = HTTPClient.new() # Create the Client.

	err = http.connect_to_host("https://www.pokeapi.co",443) # Connect to host/port
	assert(err == OK) # Make sure connection was OK.

	# Wait until resolved and connected.
	while http.get_status() == HTTPClient.STATUS_CONNECTING or http.get_status() == HTTPClient.STATUS_RESOLVING:
		http.poll()
		#print("Connecting...")
		#OS.delay_msec(500)

	assert(http.get_status() == HTTPClient.STATUS_CONNECTED) # Could not connect

	# Some headers
	var headers = [
#		"User-Agent: Pirulo/1.0 (Godot)",
#		"Accept: */*"
	]

	err = http.request(HTTPClient.METHOD_GET, uri, headers) # Request a page from the site (this one was chunked..)
	assert(err == OK) # Make sure all is OK.

	while http.get_status() == HTTPClient.STATUS_REQUESTING:
		# Keep polling for as long as the request is being processed.
		http.poll()
		#print("Requesting...")
		OS.delay_msec(500)
#		if not OS.has_feature("web"):
#			OS.delay_msec(500)
#		else:
#			# Synchronous HTTP requests are not supported on the web,
#			# so wait for the next main loop iteration.
#			yield(Engine.get_main_loop(), "idle_frame")

	#assert(http.get_status() == HTTPClient.STATUS_BODY or http.get_status() == HTTPClient.STATUS_CONNECTED) # Make sure request finished well.

#	print("response? ", http.has_response()) # Site might not have a response.
#
#	if http.has_response():
#		# If there is a response...
#
#		headers = http.get_response_headers_as_dictionary() # Get response headers.
#		print("code: ", http.get_response_code()) # Show response code.
#		print("**headers:\\n", headers) # Show headers.
#
#		# Getting the HTTP Body
#
#		if http.is_response_chunked():
#			# Does it use chunks?
#			print("Response is Chunked!")
#		else:
#		# Or just plain Content-Length
#			var bl = http.get_response_body_length()
#			print("Response Length: ",bl)

		# This method works for both anyway

	var rb = PoolByteArray() # Array that will hold the data.

	while http.get_status() == HTTPClient.STATUS_BODY:
		# While there is body left to be read
		
		http.poll()
		var chunk = http.read_response_body_chunk() # Get a chunk.

		if chunk.size() == 0:
			# Got nothing, wait for buffers to fill a bit.
			OS.delay_usec(1000)
		else:
			
			#print("rb: " + rb.get_string_from_ascii())
			rb = rb + chunk # Append to read buffer.

	# Done!
	#print(http.get_status())
	#print("bytes got: ", rb.size())
	var text = rb.get_string_from_ascii()
	print("Text: ", text)
	return text
	#return ""
	
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