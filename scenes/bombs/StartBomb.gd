extends Bomb
class_name StartBomb

signal started

func slayed():
	started.emit()
	super()

func _draw():
	draw_circle(Vector2(0,0), 30, PlayingFieldInterface.get_theme_color())
	draw_circle(Vector2(0,0), 20, Color.BLUE)
