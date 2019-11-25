EE
extends Node

export(float) var time
var t
var parentEvent = null
var parentPage = null

func _init():
	add_user_signal("finished")

func _ready():
	t = get_node("Timer")

func run():
	t.set_wait_time(time)
	t.start()
	yield(t,"timeout")
	emit_signal("finished")

func wait(s):
	var timer = Timer.new()
	timer.set_wait_time(s)
	timer.start()
	yield(timer,"timeout")
	emit_signal("finished")
