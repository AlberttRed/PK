extends Node2D

#export(String, FILE, "*.tres") var animation
export(int) var speed = 1
var parentEvent = null
var parentPage = null

onready var animationPlayer = ProjectSettings.get("Global_World").get_node("AnimationPlayer")

func _init():
	add_user_signal("finished")
	
func _ready():
	add_to_group("CMD")

func run():
	#var animation
	print("Fade Out started")
	animationPlayer.play("FadeOut", -1, 1*speed)
#	animationPlayer.add_animation("FadeOut", "res://animations/FadeIn.tres")
#	animationPlayer.set_current_animation("FadeOut")
#	animationPlayer.play("FadeOut")
		
	while animationPlayer.is_playing():
		yield(get_tree(), "idle_frame")
	ProjectSettings.get("Global_World").faded = true
	print("Fade Out finished")
	emit_signal("finished")