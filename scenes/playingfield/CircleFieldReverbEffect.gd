extends Node2D
class_name CircleFieldReverbEffect

const CIRCLE_FIELD_RADIUS = 256

var color_alpha: float = 1.0
var radius_to_draw: float = CIRCLE_FIELD_RADIUS

func _ready():
	const delay = 1.2
	
	var tween_alpha = get_tree().create_tween()
	tween_alpha.tween_property(self, "color_alpha", 0, delay)
	
	var tween_radius = get_tree().create_tween()
	tween_radius.tween_property(self, "radius_to_draw", CIRCLE_FIELD_RADIUS + 32, delay)

func _draw():
	var theme_color: Color = PlayingFieldInterface.get_theme_color()
	draw_arc(Vector2.ZERO, radius_to_draw, 0, 2*PI, 1024, Color(theme_color.r, theme_color.g, theme_color.b, color_alpha), 6, true)

func _process(_delta):
	queue_redraw()
