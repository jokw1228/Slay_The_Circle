extends Bomb
class_name StartBomb

signal started

func slayed():
	started.emit()
	super()

func _draw():
	draw_circle(Vector2(0,0), 30, Color(1,1,1))
	draw_circle(Vector2(0,0), 20, PlayingFieldInterface.get_theme_color())
