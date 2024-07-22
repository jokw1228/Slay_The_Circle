extends Bomb
class_name RotationInversionBomb

func slayed():
	PlayingFieldInterface.rotation_inversion()
	super()
	
	SoundManager.play("sfx_RI_bomb","slay")

