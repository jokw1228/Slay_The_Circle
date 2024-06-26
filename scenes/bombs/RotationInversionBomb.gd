extends Bomb
class_name RotationInversionBomb

func slayed():
	var PlayingField_node: PlayingField = PlayingFieldManager.get_PlayingField_node()
	PlayingField_node.rotation_inversion()
	super()

