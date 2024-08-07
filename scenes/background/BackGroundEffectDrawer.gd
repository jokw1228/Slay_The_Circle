extends Node2D
class_name BackGroundEffectDrawer

var radius: float
var text_to_print: String
var font: Font
var theme_color: Color

func _draw():
	draw_char(font,Vector2(0,radius),text_to_print,32,theme_color)

func _process(_delta):
	queue_redraw()
