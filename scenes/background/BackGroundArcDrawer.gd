extends Node2D
class_name BackGroundArcDrawer

const BackGroundArcDrawer_scene = "res://scenes/background/BackGroundArcDrawer.tscn"

var radius: float
var radian: float
const arc_width = 32

static func create(radius_to_set: float, radian_to_set: float, to_rotate: float) -> BackGroundArcDrawer:
	var inst: BackGroundArcDrawer = preload(BackGroundArcDrawer_scene).instantiate() as BackGroundArcDrawer
	inst.radius = radius_to_set
	inst.radian = radian_to_set
	inst.rotate(to_rotate)
	return inst

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
