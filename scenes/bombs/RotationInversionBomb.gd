extends Bomb
class_name RotationInversionBomb


func slayed():
	PlayingFieldInterface.rotation_inversion()
	super()

