extends Node2D
class_name BackGroundArcDrawer

var radius: float
var radian: float
const arc_width = 32

func _draw():
	var theme_color: Color = PlayingFieldInterface.get_theme_color()
	var theme_bright: float = PlayingFieldInterface.get_theme_bright()
	
	const base = 0.2
	var bright: float = (1.0 - base) * theme_bright * 0.9
	var arc_color: Color = Color(theme_color.r * base + bright, theme_color.g * base + bright, theme_color.b * base + bright, 1)
	
	draw_arc(Vector2.ZERO, radius, 0, radian, 64, arc_color, arc_width, true)
	draw_circle(Vector2(radius, 0), arc_width / 2.0, arc_color)
	draw_circle(Vector2(radius * cos(radian), radius * sin(radian)), arc_width / 2.0, arc_color) 

func _process(_delta):
	queue_redraw()
