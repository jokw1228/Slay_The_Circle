extends Bomb
class_name NormalBomb

func _draw():
	draw_circle(Vector2(0,0), 30, Color(1,1,1))
	draw_circle(Vector2(0,0), 20, PlayingFieldInterface.color)
