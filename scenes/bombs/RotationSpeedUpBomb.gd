extends Bomb
class_name RotationSpeedUpBomb

@export var rotation_speed_up_value: float = 0.1

func slayed():
	PlayingFieldInterface.rotation_speed_up(rotation_speed_up_value)
	super()
