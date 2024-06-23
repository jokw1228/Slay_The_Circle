extends Bomb
class_name RotationInversionBomb

func slayed():
	var camera: PlayingfieldCamera = get_tree().current_scene.get_node("PlayingfieldCamera")
	camera.rotation_inversion()
	super()

