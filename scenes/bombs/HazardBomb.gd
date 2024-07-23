extends Bomb
class_name HazardBomb
@export var font : Font
func _draw():
	draw_circle(Vector2(0,0), 30, Color(0,0,0))
	draw_circle(Vector2(0,0), 20, Color(1,1,0))
	draw_string(font, Vector2(-4,12), "!", HORIZONTAL_ALIGNMENT_LEFT, -5, 30, PlayingFieldInterface.color)
