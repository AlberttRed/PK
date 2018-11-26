extends Sprite

var fieldEffectsFlags = []

func _ready():
	pass

func hasWorkingFieldEffect(e):
	return fieldEffectsFlags.has(e)