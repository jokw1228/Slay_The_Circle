extends Node2D
class_name BackGroundArcDrawer

var radius: float
var radian: float
const arc_width = 32

func _draw():
	var theme_color: Color = Color(0.2,0.2,0.2,1)
	draw_arc(Vector2.ZERO, radius, 0, radian, 64, theme_color, arc_width, true)
	draw_circle(Vector2(radius, 0), arc_width / 2.0, theme_color)
	draw_circle(Vector2(radius * cos(radian), radius * sin(radian)), arc_width / 2.0, theme_color) 

func _process(_delta):
	queue_redraw()
