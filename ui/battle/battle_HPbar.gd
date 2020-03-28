extends Sprite

var max_value
var current_value

onready var health_bar = get_node("health_bar/health")
onready var actual_hp = get_node("lblActualHP")
var exp_bar = null
func _init():
	add_user_signal("hp_updated")
	
func _ready():
	if has_node("exp_bar"):
		exp_bar = get_node("exp_bar/exp")

func init(_max_value, _current_value):
	self.max_value = _max_value
	self.current_value = clamp(_current_value, 0, _max_value)
	
	set_health()
	
func update_health(value):
	print("mal: " + str(value))
	print("vida actual: " + str(current_value))
	var hp
	if value < 0:
		hp = -1
		value = value * hp
	else:
		hp = 1
	var current = 1
	
	while current <= value:
		current_value = clamp(current_value+hp, 0, max_value)
		current = current + 1
		update()
		yield(get_tree(), "idle_frame")
	print("vida final: " + str(current_value))
	emit_signal("hp_updated")
	
	
func set_health():
	var percentage = current_value / max_value
	print("resta percentatge: " + str(percentage))
	actual_hp.text = str(current_value)
	health_bar.rect_scale = Vector2(percentage, 1)
	
func update():
	
	#var percentage = current_value / max_value
	var percentage = 100.0 / float(max_value) / 100.0
	print("percentatge: " + str(percentage))
	actual_hp.text = str(current_value)
	health_bar.rect_scale = Vector2(health_bar.rect_scale.x-percentage, 1)
	
