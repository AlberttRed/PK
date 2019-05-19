tool

extends EditorScript


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var h
# Called when the node enters the scene tree for the first time.

func _init():
	h = HTTPRequest.new()
	#h.set_owner(get_editor_interface().get_tree().)
	connect("request_completed", h, "_on_HTTPRequest_request_completed")


func _run():
	h.request("https://www.pokeapi.co/api/v2/pokemon/"+str(1)+"/")
#	var scn = get_scene()
#
#
#	scn.set("container", scn.get_node("pokemons"))
#	if (scn.get("container") == null):
#		scn.set("container", Node.new())
#		scn.get("container").set_name("pokemons")
#		scn.add_child(scn.get("container"))
#		scn.set_owner(scn)
#
#	scn.set("names", PoolStringArray())
#	scn.get("names").push_back("None")
#
#	for i in range(1):  #maxim son 721
#		scn.set("index", i)
#		scn.set("object", "pokemon")
#		#var text = get_json("/api/v2/pokemon/"+str(i+1)+"/")
#		#var h = HTTPRequest.new()
#		h.request("https://www.pokeapi.co/api/v2/pokemon/"+str(i+1)+"/")
#	scn.set("index", 0)


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	print("eeei muy buenas a todos")
#	var scn = get_scene()
#	if (scn == null || scn.get_name() != "DB"):
#		print("WARNING: not in Database scene!")
#		return
#	var http = HTTPClient.new()
#	var err = http.connect_to_host("https://www.pokeapi.co", 443, true) # Connect to host/port
#
#	if err != OK:
#	    return
#
#	while (http.get_status() == HTTPClient.STATUS_REQUESTING):
#	    http.poll()
#	    OS.delay_msec(500)
#
#	if http.get_status() != HTTPClient.STATUS_BODY and http.get_status() != HTTPClient.STATUS_CONNECTED:
#	    return
#
#	if !http.has_response():
#	    return
#
#	err = http.request(0, "/api/v2/pokemon/1", PoolStringArray())#http://www.mocky.io/v2/5185415ba171ea3a00704eed")
#	print("jaja")
#	print(http.get_string_from_utf8())

	#var d = parse_json(http.get_string_from_utf8())

func _on_Button_pressed():
#	var h = HTTPRequest.new()
#	h.request("http://www.mocky.io/v2/5185415ba171ea3a00704eed")#https://www.pokeapi.co/api/v2/pokemon/1")
	HTTPRequest.new().request("https://www.pokeapi.co/api/v2/pokemon/1")#http://www.mocky.io/v2/5185415ba171ea3a00704eed")

#
#func _on_HTTPRequest_request_completed(result, response_code, headers, body):
##	var json = JSON.parse(body.get_string_from_utf8())
##
##	var d = parse_json(body.get_string_from_utf8())
##
#	print(headers)#json.result)
#
#
