extends AudioStreamPlayer

onready var tween_out = Tween.new()
onready var tween_in = Tween.new()
export(bool) var sound_on = true
var sound = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	add_user_signal("stopped")
	add_user_signal("played")
	add_child(tween_in)
	add_child(tween_out)
	tween_out.connect("tween_completed", self, "_on_TweenOut_tween_completed")
	tween_in.connect("tween_completed", self, "_on_TweenIn_tween_completed")
	if sound_on:
		sound = 0
	else:
		sound = -80

func play_music(music, fade_time = 0):
	if fade_time != 0:
		tween_in.interpolate_property(self, "volume_db", volume_db, sound, fade_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
		tween_in.start()
	else:
		volume_db = sound
	set_stream(music)
	play()
	if fade_time == 0:
		emit_signal("played")
	
func stop_music(fade_time = 0):
	if fade_time != 0:
		tween_out.interpolate_property(self, "volume_db", volume_db, -80, fade_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
		tween_out.start()
	else:
		volume_db = -80

func _on_TweenOut_tween_completed(object, key):
	object.stop()
	emit_signal("stopped")
	
func _on_TweenIn_tween_completed(object, key):
	emit_signal("played")
	
func play_sound(sound_to_play):
	set_stream(sound_to_play)
	play()
	yield(self, "finished")
	stop()
	emit_signal("played")
