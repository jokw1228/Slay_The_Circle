extends Bomb
class_name NormalBomb

func slayed():
	super()
	
	SoundManager.play("sfx_Nor_bomb","slay")
	
func _draw():
	draw_circle(Vector2(0,0), 30, PlayingFieldInterface.get_theme_color())
	draw_circle(Vector2(0,0), 20, Color.WHITE)
