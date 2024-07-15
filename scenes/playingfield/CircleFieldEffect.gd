extends Node2D

const CircleFieldRadius = 256
var PlayingFieldColor = Color.WHITE

var radius_delta: float = 12
var alpha_delta: float = -0.1

var accumulated_radius: float = CircleFieldRadius
var accumulated_alpha: float = 1

func _draw():
	draw_arc(position, accumulated_radius, 0, 2 * PI, 50, Color(PlayingFieldColor.r, PlayingFieldColor.g, PlayingFieldColor.b, accumulated_alpha), 8.0, false)

func _process(delta):
	accumulated_radius += delta * radius_delta
	accumulated_alpha += delta * alpha_delta
	if accumulated_alpha <= 0:
		queue_free()
	queue_redraw()
