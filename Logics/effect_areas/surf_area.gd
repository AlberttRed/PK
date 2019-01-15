extends Area2D

export(int) var cells_jump #setget set_cells_jump,get_cells_jump
export(String) var direction #setget set_cells_jump,get_cells_jump


func _init():
	add_to_group("surf_area")

func _ready():
#	connect("area_entered", self, "on_area_enter")
#	connect("area_exited",self, "on_area_exit")
	pass
#	Globals.get("player").add_exeception(self)
#	for mov in get_tree().get_nodes_in_group("movable"):
#		mov.add_exeception(self)

#func on_area_enter(area):
#	if (area.is_in_group("Player")): #== Globals.get("player")):
#		area.get_parent().connect("jump", self, "jump_player")

#
#func on_area_exit(area):
#	if (area.is_in_group("Player")):#if (area == Globals.get("player")):
#		area.get_parent().disconnect("move", self, "calculate_encounter")
#
#func jump_player():
#	print("jumped")
#	var rate = rand_range(0,100)
#	if (rate <= encounter_rate):
#		var p = int(floor(rand_range(0, 10)))
#		if pkmn[p] > 0 && pkmn[p]<=751:
#			print("found! " + DB.pokemons[pkmn[p]].name)
# aquest es el bo			GUI.init_battle(GAME_DATA.party[0], DB.pokemons[pkmn[p]].make_wild(floor(rand_range(min_lvl,max_lvl+1))))
			#GUI.wild_encounter(pkmn[p], floor(rand_range(min_lvl,max_lvl+1)))

func set_cells_jump(cells):
	cells_jump = cells

func get_cells_jump():
	return cells_jump

func set_direction(to):
	direction = to

func get_direction():
	return direction
