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

func init(max_value, current_value):
	self.max_value = max_value
	self.current_value = clamp(current_value, 0, max_value)
	
	update()
	
func set_health(value):
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
	emit_signal("hp_updated")
	
func update():
	
	var percentage = current_value / max_value
	actual_hp.text = str(current_value)
	health_bar.rect_scale = Vector2(percentage, 1)
	