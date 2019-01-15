
extends Node

var player_name = "RED"
var trainer
var medals = []

var party = []
var box1 = []
var box2 = []
var box3 = []
var box4 = []
var box5 = []
var box6 = []
var box7 = []
var box8 = []
var box9 = []
var box10 = []
var box11 = []
var box12 = []
var box13 = []
var box14 = []
var box15 = []
var box16 = []
var box17 = []
var box18 = []
var box19 = []
var box20 = []

var battle_front_sprite = preload("res://Sprites/Characters/trainer000.png")
var battle_back_sprite = preload("res://Sprites/Characters/trback000.png")

var player_surf_sprite = preload("res://Sprites/Characters/boy_dive_offset.png")
var player_default_sprite = preload("res://Sprites/trchar000.png")

func _ready():
	party.push_back(DB.pokemons[7].make_wild(7))
	party.push_back(DB.pokemons[4].make_wild(16))
	
	medals.push_back(CONST.MEDALS.ROCA)
	medals.push_back(CONST.MEDALS.CASCADA)
	medals.push_back(CONST.MEDALS.TRUENO)
	medals.push_back(CONST.MEDALS.ARCOIRIS)
	medals.push_back(CONST.MEDALS.ALMA)
	medals.push_back(CONST.MEDALS.PANTANO)
	medals.push_back(CONST.MEDALS.VOLCAN)
	medals.push_back(CONST.MEDALS.TIERRA)
	
