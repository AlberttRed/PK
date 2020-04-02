extends Node2D

#export(String, FILE, "*.tres") var animation
export(Animation) var animation
 
onready var animationPlayer = get_node("AnimationPlayer")
var parentEvent = null
var parentPage = null

func _init():
	add_user_signal("finished")
	
func _ready():
	pass

func run():
	print("show animation started")
	if animation != null:
		animationPlayer.add_animation(animation.get_name(), animation)
		animationPlayer.play(animation.get_name())
		
		while animationPlayer.is_playing():
			yield(get_tree(), "idle_frame")
	print("show animation finished")
	emit_signal("finished")
