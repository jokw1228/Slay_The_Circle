extends Bomb
class_name NormalBomb

func slayed():
	super()
	
	SoundManager.play("sfx_Nor_bomb","slay")


