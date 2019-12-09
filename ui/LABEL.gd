extends Label

 
export(int) var font_size
export(Color) var font_color
export(Color) var outline_color
export(DynamicFont) var text_font
export(bool) var block_outline = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$Outline.text = text
	set("custom_fonts/font", text_font)
	$Outline.set("custom_fonts/font", text_font)
	get("custom_fonts/font").set_size(font_size)
	$Outline.get("custom_fonts/font").set_size(font_size)
	set("custom_colors/default_color", font_color)
	$Outline.set("custom_colors/default_color", font_color)
	set("custom_colors/font_color_shadow", outline_color)
	$Outline.set("custom_colors/font_color_shadow", outline_color)
	if block_outline:
		$Outline.rect_position = Vector2(0, 0)
		$Outline.rect_size = rect_size
		$Outline.align = align

func set_text(_text):
	text = _text
	$Outline.text = _text
