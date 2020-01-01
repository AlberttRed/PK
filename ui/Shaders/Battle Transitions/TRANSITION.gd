extends Panel


func _ready():
	hide()
	add_user_signal("finished")
	
func play(animation):
	$AnimationPlayer.play(animation)
	yield($AnimationPlayer, "animation_finished")
	emit_signal("finished")