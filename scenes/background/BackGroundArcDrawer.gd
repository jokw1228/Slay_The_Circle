extends Node2D
class_name BackGroundArcDrawer

var radius: float
var radian: float
const arc_width = 32

func _draw():
	var theme_color: Color = PlayingFieldInterface.get_theme_color()
	var arc_color: Color = Color(theme_color.r / 5, theme_color.g / 5, theme_color.b / 5,1)
	draw_arc(Vector2.ZERO, radius, 0, radian, 64, arc_color, arc_width, true)
	draw_circle(Vector2(radius, 0), arc_width / 2.0, arc_color)
	draw_circle(Vector2(radius * cos(radian), radius * sin(radian)), arc_width / 2.0, arc_color) 

func _process(_delta):
	queue_redraw()
