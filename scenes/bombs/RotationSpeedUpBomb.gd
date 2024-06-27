extends Bomb
class_name RotationSpeedUpBomb

func slayed():
	var PlayingField_node: PlayingField = PlayingFieldInterface.get_PlayingField_node()
	PlayingField_node.rotation_speed_up(PI / 16)
	super()
