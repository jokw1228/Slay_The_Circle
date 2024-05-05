extends Node2D

func _draw():
	draw_arc(position, 256, 0, 2 * PI, 25, Color.WHITE, 4.0, false)
