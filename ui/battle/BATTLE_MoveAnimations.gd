extends Node

var animations = {"Move_Animation001":Move_Animation001, "Move_Animation002":Move_Animation002, "Move_Animationn003":Move_Animation003} # create an empty Dictionary

#	functions["Move_Function001"] = Move_Function001.new() #store initial int value
#	functions["Move_Function002"] = Move_Function002.new()
#	print("FUNCTIONS")

class Move_Animation001:# extends "res://Logics/game_data/move_instance.gd":#"res://Logics/DB/pokemon_move.gd":
	
	func _init():
		add_user_signal("animation_done")
		
	func ShowAnimation(from,to):
		
		print(to.node.get_name())
		var spritesheet = load("res://ui/BattleAnimations/1. Destructor/destructor_frames.png")
		var n = Sprite.new()
		n.set_name("star")
		n.hframes = 2
		n.frame = 0
		n.texture = spritesheet
		to.node.get_node("FrameAnimations").add_child(n)
		n = Sprite.new()
		n.set_name("bubble")
		n.hframes = 2
		n.frame = 1
		n.texture = spritesheet
		to.node.get_node("FrameAnimations").add_child(n)
		n = Sprite.new()
		n.set_name("bubble2")
		n.hframes = 2
		n.frame = 1
		n.texture = spritesheet
		to.node.get_node("FrameAnimations").add_child(n)
		n = Sprite.new()
		n.set_name("bubble3")
		n.hframes = 2
		n.frame = 1
		n.texture = spritesheet
		to.node.get_node("FrameAnimations").add_child(n)
		n = Sprite.new()
		n.set_name("bubble4")
		n.hframes = 2
		n.frame = 1
		n.texture = spritesheet
		to.node.get_node("FrameAnimations").add_child(n)
		n = Sprite.new()
		n.set_name("bubble5")
		n.hframes = 2
		n.frame = 1
		n.texture = spritesheet
		to.node.get_node("FrameAnimations").add_child(n)
		n = Sprite.new()
		n.set_name("bubble6")
		n.hframes = 2
		n.frame = 1
		n.texture = spritesheet
		to.node.get_node("FrameAnimations").add_child(n)
		n.set_name("bubble7")
		n.hframes = 2
		n.frame = 1
		n.texture = spritesheet
		to.node.get_node("FrameAnimations").add_child(n)
		n.set_name("bubble8")
		n.hframes = 2
		n.frame = 1
		n.texture = spritesheet
		to.node.get_node("FrameAnimations").add_child(n)
		
		to.node.get_node("AnimationPlayer").play("Destructor")		
		yield(to.node.get_node("AnimationPlayer"), "animation_finished")
		to.node.get_node("AnimationPlayer").play("Hurt")		
		yield(to.node.get_node("AnimationPlayer"), "animation_finished")
		for c in to.node.get_node("FrameAnimations").get_children():
			print(c.get_name())
			if c.get_name() != "AnimationPlayer":
				GLOBAL.queue(c)
		emit_signal("animation_done")


class Move_Animation002:# extends "res://Logics/game_data/move_instance.gd":#"res://Logics/DB/pokemon_move.gd":
	func ShowAnimation(from,to):
		ProjectSettings.get("Battle_AnimationPlayer").play("Stat_Down")
		
class Move_Animation003:# extends "res://Logics/game_data/move_instance.gd":#"res://Logics/DB/pokemon_move.gd":
	func ShowAnimation(from,to):
		ProjectSettings.get("Battle_AnimationPlayer").play("Heal")
		
class Move_Animation999:# extends "res://Logics/game_data/move_instance.gd":#"res://Logics/DB/pokemon_move.gd":	
	func ShowAnimation(from,to):
		var anim = ProjectSettings.get("Battle_AnimationPlayer")
		if anim.has_animation("001"):
			anim.remove_animation("001")
		anim.add_animation("001",Animation.new())
		var animation = anim.get_animation("001")
		animation.length = 1.5
		
		animation.add_track(Animation.TYPE_VALUE)
		animation.track_set_path(0, "Background/" + to.node.get_parent().name + "/" + to.node.name + ":material")
		animation.value_track_set_update_mode(0, 1)
		
		animation.add_track(Animation.TYPE_VALUE)
		animation.track_set_path(1, "Background/" + to.node.get_parent().name + "/" + to.node.name + ":material:shader_param/frame1")
		animation.value_track_set_update_mode(1, 1)
		animation.track_insert_key(1, 0.0, load("res://ui/BattleAnimations/OverlayStatUp.png"))
		animation.track_insert_key(1, 1.5, null)
		
		animation.add_track(Animation.TYPE_VALUE)
		animation.track_set_path(2, "Background/" + to.node.get_parent().name + "/" + to.node.name + ":material:shader_param/whitening")
		animation.value_track_set_update_mode(2, 1)
		animation.track_insert_key(2, 0.0, 0.4)
		animation.track_insert_key(2, 1.5, 0.0)
		
		animation.add_track(Animation.TYPE_VALUE)
		animation.track_set_path(3, "Background/" + to.node.get_parent().name + "/" + to.node.name + ":material:shader_param/frame_size")
		animation.value_track_set_update_mode(3, 1)
		animation.track_insert_key(3, 0.0, 5.0)
		animation.track_insert_key(3, 1.5, 0.0)
		
		animation.add_track(Animation.TYPE_VALUE)
		animation.track_set_path(4, "Background/" + to.node.get_parent().name + "/" + to.node.name + ":material:shader_param/frames")
		animation.value_track_set_update_mode(4, 1)
		animation.track_insert_key(4, 0.0, 8.0)
		animation.track_insert_key(4, 1.5, 0.0)
		
		animation.add_track(Animation.TYPE_VALUE)
		animation.track_set_path(5, "Background/" + to.node.get_parent().name + "/" + to.node.name + ":material:shader_param/anim_time")
		animation.value_track_set_update_mode(5, 1)
		animation.track_insert_key(5, 0.0, 1.0)
		animation.track_insert_key(5, 1.5, 0.0)
		anim.play("001")
