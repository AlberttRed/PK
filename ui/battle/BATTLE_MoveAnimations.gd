extends Node

var animations = {"Move_Animation001":Move_Animation001, "Move_Animation002":Move_Animation002, "Move_Animationn003":Move_Animation003} # create an empty Dictionary

#	functions["Move_Function001"] = Move_Function001.new() #store initial int value
#	functions["Move_Function002"] = Move_Function002.new()
#	print("FUNCTIONS")

class Move_Animation001:# extends "res://Logics/game_data/move_instance.gd":#"res://Logics/DB/pokemon_move.gd":	
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

class Move_Animation002:# extends "res://Logics/game_data/move_instance.gd":#"res://Logics/DB/pokemon_move.gd":
	func ShowAnimation(from,to):
		ProjectSettings.get("Battle_AnimationPlayer").play("Stat_Down")
		
class Move_Animation003:# extends "res://Logics/game_data/move_instance.gd":#"res://Logics/DB/pokemon_move.gd":
	func ShowAnimation(from,to):
		ProjectSettings.get("Battle_AnimationPlayer").play("Heal")