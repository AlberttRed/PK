extends Node2D

#export(String, FILE, "*.tres") var animation
export(Animation) var animation
export(bool)var wait_finished = false
var i = 0
var count = false
onready var animationPlayer = get_parent().get_parent().get_parent().get_node("AnimationPlayer")
var executing = false
var parentEvent = null
var parentPage = null

func _init():
	add_user_signal("finished")
	
func _ready():
	add_to_group("CMD")

func _process(delta):
	if count:
		i += 1

func run():
	executing = true
	print("show animation started")
	if animation != null:
		animationPlayer.add_animation(animation.get_name(), animation)
		animationPlayer.play(animation.get_name())
		yield(animationPlayer, "animation_finished")
		if wait_finished:
			while animationPlayer.is_playing():
				#print("pa")
				yield(get_tree(), "idle_frame")
			wait_finished = false
		while i < 1:
			count = true
			yield(get_tree(), "idle_frame")
		count = false
	animationPlayer.remove_animation(animation.get_name())
	print("show animation finished")
	executing = false
	emit_signal("finished")