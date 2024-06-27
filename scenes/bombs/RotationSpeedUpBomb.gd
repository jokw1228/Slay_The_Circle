extends Bomb
class_name RotationSpeedUpBomb

func slayed():
	PlayingFieldInterface.rotation_speed_up(PI / 16)
	super()
