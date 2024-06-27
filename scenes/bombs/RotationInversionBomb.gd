extends Bomb
class_name RotationInversionBomb

func slayed():
	var PlayingField_node: PlayingField = PlayingFieldInterface.get_PlayingField_node()
	PlayingField_node.rotation_inversion()
	super()

